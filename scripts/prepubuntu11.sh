#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'Usage: %s <username> <private-key-file> <host1> [host2 ...]\n' "$0" >&2
    printf 'Hosts may be separate arguments or comma-separated.\n' >&2
    printf 'The private key must have a matching .pub file; sshpass is required.\n' >&2
    exit 2
}

[[ $# -ge 3 ]] || usage

remote_user=$1
key_file=${2/#\~/$HOME}
servers=()
for host_argument in "${@:3}"; do
    IFS=',' read -r -a host_list <<< "$host_argument"
    for server in "${host_list[@]}"; do
        if [[ ! "$server" =~ ^[A-Za-z0-9][A-Za-z0-9._:-]*$ ]]; then
            printf 'ERROR: invalid host name or IP address: %s\n' "$server" >&2
            exit 2
        fi
        servers+=("$server")
    done
done
(( ${#servers[@]} > 0 )) || usage

if [[ ! "$remote_user" =~ ^[a-z_][a-z0-9_-]*\$?$ ]]; then
    printf 'ERROR: unsupported remote username: %s\n' "$remote_user" >&2
    exit 2
fi

if [[ "$key_file" == *.pub ]]; then
    public_key_file=$key_file
    identity_file=${key_file%.pub}
else
    identity_file=$key_file
    public_key_file="${key_file}.pub"
fi

if [[ ! -r "$identity_file" || ! -r "$public_key_file" ]]; then
    printf 'ERROR: need a readable private key and its matching .pub file.\n' >&2
    printf 'Private key: %s\nPublic key: %s\n' "$identity_file" "$public_key_file" >&2
    exit 2
fi

private_key_name=${identity_file##*/}
if [[ ! "$private_key_name" =~ ^[A-Za-z0-9._-]+$ || "$private_key_name" == . || "$private_key_name" == .. ]]; then
    printf 'ERROR: private key filename must contain only letters, numbers, dots, underscores, or hyphens.\n' >&2
    exit 2
fi

if ! public_key=$(<"$public_key_file") || [[ -z "$public_key" ]]; then
    printf 'ERROR: public key file is empty: %s\n' "$public_key_file" >&2
    exit 2
fi

if ! ssh-keygen -lf "$public_key_file" >/dev/null; then
    printf 'ERROR: invalid SSH public key: %s\n' "$public_key_file" >&2
    exit 2
fi

public_key_b64=$(base64 < "$public_key_file" | tr -d '\n')
upload_command='umask 077; cat > "$HOME/.prepubuntu11-remote.sh"'
remote_command='sudo -S bash "$HOME/.prepubuntu11-remote.sh"'
ssh_options=(-o PubkeyAuthentication=no -o PreferredAuthentications=password,keyboard-interactive)

if ! command -v sshpass >/dev/null 2>&1; then
    printf 'ERROR: sshpass is required to provide the password at startup (for example: brew install sshpass).\n' >&2
    exit 1
fi

read -r -s -p "Password for ${remote_user} (used for all hosts): " remote_password
printf '\n'
trap 'unset remote_password' EXIT

run_for_host() {
    local server=$1
    local run_token="$$-${RANDOM}-${RANDOM}"
    local marker_name=".prepubuntu11-${run_token}.complete"
    local remote_status=0
    local marker_check="test -f \"\$HOME/${marker_name}\" && rm -f -- \"\$HOME/${marker_name}\""
    local key_ssh_options=(-i "$identity_file" -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=5 -o PreferredAuthentications=publickey -o PasswordAuthentication=no)

    printf '\n===== %s@%s =====\n' "$remote_user" "$server"
    printf 'Uploading setup script.\n'
{
    cat <<'REMOTE_SCRIPT'
set -euo pipefail
REMOTE_SCRIPT
    printf "remote_user='%s'\n" "$remote_user"
    printf "public_key_b64='%s'\n" "$public_key_b64"
    printf "private_key_name='%s'\n" "$private_key_name"
    printf "run_token='%s'\n" "$run_token"
    printf "private_key_b64='"
    base64 < "$identity_file" | tr -d '\n'
    printf "'\n"
    cat <<'REMOTE_SCRIPT'

remote_script_path=$0
trap 'rm -f -- "$remote_script_path"' EXIT

if [[ $EUID -ne 0 ]]; then
    printf 'ERROR: remote sudo did not provide a root shell.\n' >&2
    exit 1
fi

if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ ${ID:-} != ubuntu ]]; then
    printf 'ERROR: this script supports Ubuntu only.\n' >&2
    exit 1
fi

if ! id "$remote_user" >/dev/null 2>&1; then
    printf 'ERROR: remote user does not exist: %s\n' "$remote_user" >&2
    exit 1
fi

public_key=$(printf '%s' "$public_key_b64" | base64 -d)
if [[ -z "$public_key" ]]; then
    printf 'ERROR: could not decode the supplied public key.\n' >&2
    exit 1
fi

printf '\n===== System update =====\n'
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y full-upgrade
apt-get -y install --no-install-recommends \
    net-tools iftop unzip wget plocate nfs-common bat

printf '\n===== Timezone =====\n'
timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

printf '\n===== Bash prompts =====\n'
prompt_line="PS1='\\[\\e[36m\\][\\A-\\D{%Y.%m.%d}] \\u@\\h:\\[\\e[32m\\]\${PWD}\\[\\e[0m\\] \\$ '"
configure_prompt() {
    local profile=$1
    touch "$profile"
    sed -i '/^# >>> prepubuntu11 prompt >>>$/,/^# <<< prepubuntu11 prompt <<<$/{d;}' "$profile"
    {
        printf '%s\n' '# >>> prepubuntu11 prompt >>>'
        printf '%s\n' "$prompt_line"
        printf '%s\n' '# <<< prepubuntu11 prompt <<<'
    } >> "$profile"
}

IFS=: read -r _ _ _ _ _ user_home _ < <(getent passwd "$remote_user")
if [[ -z "$user_home" || ! -d "$user_home" ]]; then
    printf 'ERROR: could not find the home directory for %s.\n' "$remote_user" >&2
    exit 1
fi
configure_prompt "$user_home/.bashrc"
configure_prompt /root/.bashrc
chown "$remote_user:$(id -gn "$remote_user")" "$user_home/.bashrc"

printf '\n===== Firewall and SELinux =====\n'
if command -v ufw >/dev/null 2>&1; then
    ufw --force disable
fi
if command -v getenforce >/dev/null 2>&1 && [[ $(getenforce) == Enforcing ]]; then
    setenforce 0
fi
if [[ -f /etc/selinux/config ]]; then
    if grep -qE '^[[:space:]]*SELINUX=' /etc/selinux/config; then
        sed -i 's/^[[:space:]]*SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    else
        printf '\nSELINUX=disabled\n' >> /etc/selinux/config
    fi
fi

printf '\n===== IPv6 =====\n'
cat > /etc/sysctl.d/99-prepubuntu11-disable-ipv6.conf <<'SYSCTL'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
SYSCTL
sysctl --system

printf '\n===== Passwordless sudo =====\n'
sudoers_file="/etc/sudoers.d/90-prepubuntu11-${remote_user}"
printf '%s ALL=(ALL:ALL) NOPASSWD:ALL\n' "$remote_user" > "$sudoers_file"
chmod 0440 "$sudoers_file"
visudo -cf "$sudoers_file"

printf '\n===== SSH public keys =====\n'
user_group=$(id -gn "$remote_user")
for account_home in "$user_home" /root; do
    ssh_directory="${account_home}/.ssh"
    authorized_keys="${ssh_directory}/authorized_keys"
    mkdir -p "$ssh_directory"
    chmod 0700 "$ssh_directory"
    touch "$authorized_keys"
    chmod 0600 "$authorized_keys"
    if ! grep -qxF -- "$public_key" "$authorized_keys"; then
        printf '%s\n' "$public_key" >> "$authorized_keys"
    fi
    if [[ "$account_home" == /root ]]; then
        chown -R root:root "$ssh_directory"
    else
        chown -R "$remote_user:$user_group" "$ssh_directory"
    fi
done

private_key_path="${user_home}/.ssh/${private_key_name}"
umask 077
printf '%s' "$private_key_b64" | base64 -d > "$private_key_path"
chown "$remote_user:$user_group" "$private_key_path"
chmod 0600 "$private_key_path"

ssh_config_dir=/etc/ssh/sshd_config.d
mkdir -p "$ssh_config_dir"
printf '%s\n' 'PermitRootLogin prohibit-password' > "$ssh_config_dir/00-prepubuntu11-root-key.conf"
chmod 0644 "$ssh_config_dir/00-prepubuntu11-root-key.conf"
sshd -t
if ! sshd -T | grep -Eq '^permitrootlogin (prohibit-password|without-password)$'; then
    root_login=$(sshd -T | awk '$1 == "permitrootlogin" { print $2; exit }')
    printf 'ERROR: SSH root login policy is %s; key-only root login was expected.\n' "${root_login:-unknown}" >&2
    exit 1
fi
completion_marker="${user_home}/.prepubuntu11-${run_token}.complete"
: > "$completion_marker"
chown "$remote_user:$user_group" "$completion_marker"
chmod 0600 "$completion_marker"
systemctl reload ssh

printf '\nUbuntu server preparation complete. Root SSH access is restricted to public-key authentication.\n'
REMOTE_SCRIPT
    } | SSHPASS="$remote_password" sshpass -e ssh "${ssh_options[@]}" -l "$remote_user" "$server" "$upload_command" || return $?

    printf 'Running setup.\n'
    if printf '%s\n' "$remote_password" | SSHPASS="$remote_password" sshpass -e ssh "${ssh_options[@]}" -l "$remote_user" "$server" "$remote_command"; then
        remote_status=0
    else
        remote_status=$?
    fi

    if ssh "${key_ssh_options[@]}" -l root "$server" true && \
       ssh "${key_ssh_options[@]}" -l "$remote_user" "$server" "$marker_check"; then
        printf 'Setup completed and user/root key access verified on %s.\n' "$server"
        return 0
    fi

    printf 'ERROR: setup or key-access verification failed for %s (remote status %s).\n' "$server" "$remote_status" >&2
    return 1
}

failed_servers=()
for server in "${servers[@]}"; do
    if ! run_for_host "$server"; then
        printf 'ERROR: setup failed for %s.\n' "$server" >&2
        failed_servers+=("$server")
    fi
done

if (( ${#failed_servers[@]} > 0 )); then
    printf 'Setup failed for: %s\n' "${failed_servers[*]}" >&2
    exit 1
fi

printf '\nSetup completed successfully on all %d host(s).\n' "${#servers[@]}"
