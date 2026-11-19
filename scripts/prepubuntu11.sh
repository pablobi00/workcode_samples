#!/usr/bin/env bash
set -euo pipefail

# Print usage help and exit with an error code.
usage() {
    printf 'Usage: %s [-n|--dry-run] <username> <private-key-file> <host1> [host2 ...]\n' "$0" >&2
    printf 'Hosts may be separate arguments or comma-separated.\n' >&2
    printf 'The private key must have a matching .pub file.\n' >&2
    printf 'Each host is tried with the key first; if that fails you are prompted for a\n' >&2
    printf 'username and password (sshpass is required only in that case).\n' >&2
    printf '  -n, --dry-run   Check connectivity/auth and show what would be done; change nothing.\n' >&2
    exit 2
}

# Parse options (--dry-run, --help) and collect positional arguments.
dry_run=0
positional=()
while (( $# > 0 )); do
    case $1 in
        -n|--dry-run) dry_run=1 ;;
        -h|--help) usage ;;
        --) shift; positional+=("$@"); break ;;
        -*) printf 'ERROR: unknown option: %s\n' "$1" >&2; usage ;;
        *) positional+=("$1") ;;
    esac
    shift
done
set -- "${positional[@]+"${positional[@]}"}"

# Require at least a username, a key file and one host.
[[ $# -ge 3 ]] || usage

# Read the username and key path, then split and validate the host list.
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

# Validate the remote username format.
if [[ ! "$remote_user" =~ ^[a-z_][a-z0-9_-]*\$?$ ]]; then
    printf 'ERROR: unsupported remote username: %s\n' "$remote_user" >&2
    exit 2
fi

# Work out the private and public key paths from the supplied key file.
if [[ "$key_file" == *.pub ]]; then
    public_key_file=$key_file
    identity_file=${key_file%.pub}
else
    identity_file=$key_file
    public_key_file="${key_file}.pub"
fi

# Make sure both key files exist and are readable.
if [[ ! -r "$identity_file" || ! -r "$public_key_file" ]]; then
    printf 'ERROR: need a readable private key and its matching .pub file.\n' >&2
    printf 'Private key: %s\nPublic key: %s\n' "$identity_file" "$public_key_file" >&2
    exit 2
fi

# Make sure the private key filename is safe to use on the remote host.
private_key_name=${identity_file##*/}
if [[ ! "$private_key_name" =~ ^[A-Za-z0-9._-]+$ || "$private_key_name" == . || "$private_key_name" == .. ]]; then
    printf 'ERROR: private key filename must contain only letters, numbers, dots, underscores, or hyphens.\n' >&2
    exit 2
fi

# Load the public key and make sure it is not empty.
if ! public_key=$(<"$public_key_file") || [[ -z "$public_key" ]]; then
    printf 'ERROR: public key file is empty: %s\n' "$public_key_file" >&2
    exit 2
fi

# Check that the public key is a valid SSH key.
if ! ssh-keygen -lf "$public_key_file" >/dev/null; then
    printf 'ERROR: invalid SSH public key: %s\n' "$public_key_file" >&2
    exit 2
fi

# Define the remote commands and the SSH options for password and key logins.
public_key_b64=$(base64 < "$public_key_file" | tr -d '\n')
upload_command='umask 077; cat > "$HOME/.prepubuntu11-remote.sh"'
remote_command_sudo_password='sudo -S -p "" bash "$HOME/.prepubuntu11-remote.sh"'
remote_command_sudo_nopasswd='sudo -n bash "$HOME/.prepubuntu11-remote.sh"'
ssh_options=(-o PubkeyAuthentication=no -o PreferredAuthentications=password,keyboard-interactive -o ConnectTimeout=10)
key_ssh_options=(-i "$identity_file" -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=5 -o PreferredAuthentications=publickey -o PasswordAuthentication=no)

# Credentials entered interactively are cached and reused for later hosts.
cached_user=''
remote_password=''
trap 'unset remote_password' EXIT

# Per-host connection state, set by connect_host.
conn_mode=''   # key | password
conn_user=''
sudo_mode=''   # nopasswd | password

# Return success if the username has a supported format.
valid_username() {
    [[ "$1" =~ ^[a-z_][a-z0-9_-]*\$?$ ]]
}

# Fail with a hint if sshpass is not installed.
require_sshpass() {
    if ! command -v sshpass >/dev/null 2>&1; then
        printf 'ERROR: sshpass is required for password login (for example: brew install sshpass).\n' >&2
        return 1
    fi
}

# Ask for a username (with a default) and password, and cache them.
prompt_credentials() {
    local server=$1 default_user=$2 entered_user
    while :; do
        read -r -p "Username for ${server} [${default_user}]: " entered_user </dev/tty || return 1
        entered_user=${entered_user:-$default_user}
        valid_username "$entered_user" && break
        printf 'Unsupported username: %s\n' "$entered_user" >&2
    done
    read -r -s -p "Password for ${entered_user}@${server}: " remote_password </dev/tty || return 1
    printf '\n' >/dev/tty
    cached_user=$entered_user
}

# Ask for the sudo password when key login works but sudo needs a password.
prompt_sudo_password() {
    local server=$1
    read -r -s -p "sudo password for ${conn_user}@${server}: " remote_password </dev/tty || return 1
    printf '\n' >/dev/tty
}

# Run a command on the current host using the selected auth mode; stdin is passed through.
remote_ssh() {
    local server=$1; shift
    if [[ $conn_mode == key ]]; then
        ssh "${key_ssh_options[@]}" -l "$conn_user" "$server" "$@"
    else
        SSHPASS="$remote_password" sshpass -e ssh "${ssh_options[@]}" -l "$conn_user" "$server" "$@"
    fi
}

# Try key login first; fall back to prompting for username/password.
connect_host() {
    local server=$1 attempt
    conn_mode='' conn_user='' sudo_mode=''

    # Try key login first, then check whether sudo works without a password.
    if ssh "${key_ssh_options[@]}" -l "$remote_user" "$server" true 2>/dev/null; then
        conn_mode=key
        conn_user=$remote_user
        printf 'Key login as %s: OK\n' "$conn_user"
        if ssh "${key_ssh_options[@]}" -l "$conn_user" "$server" 'sudo -n true' 2>/dev/null; then
            sudo_mode=nopasswd
            printf 'Passwordless sudo: available\n'
        else
            sudo_mode=password
            printf 'Passwordless sudo: not available (sudo password needed)\n'
            if (( dry_run )); then
                return 0
            fi
            if [[ -z "$remote_password" || "$cached_user" != "$conn_user" ]]; then
                prompt_sudo_password "$server" || return 1
                cached_user=$conn_user
            fi
        fi
        return 0
    fi

    # Key login failed: in dry-run just report what would happen.
    printf 'Key login as %s: FAILED\n' "$remote_user"
    if (( dry_run )); then
        conn_mode=password
        printf '[dry-run] Would prompt for username and password for %s.\n' "$server"
        return 0
    fi

    # Prompt for username/password and test the login, up to 3 attempts.
    require_sshpass || return 1
    conn_mode=password
    sudo_mode=password
    for attempt in 1 2 3; do
        if [[ -z "$remote_password" || $attempt -gt 1 ]]; then
            prompt_credentials "$server" "${cached_user:-$remote_user}" || return 1
        else
            printf 'Using previously entered credentials for %s.\n' "$cached_user"
        fi
        conn_user=$cached_user
        if SSHPASS="$remote_password" sshpass -e ssh "${ssh_options[@]}" -l "$conn_user" "$server" true; then
            printf 'Password login as %s: OK\n' "$conn_user"
            return 0
        fi
        printf 'Password login as %s failed (attempt %d/3).\n' "$conn_user" "$attempt" >&2
    done
    return 1
}

# Write the remote setup script (with the user, keys and run token embedded) to stdout.
build_remote_script() {
    local remote_user=$1
    local run_token=$2
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

# Delete the uploaded script from the remote host when it exits.
remote_script_path=$0
trap 'rm -f -- "$remote_script_path"' EXIT

# Make sure the script is running as root.
if [[ $EUID -ne 0 ]]; then
    printf 'ERROR: remote sudo did not provide a root shell.\n' >&2
    exit 1
fi

# Make sure the remote host is Ubuntu.
if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ ${ID:-} != ubuntu ]]; then
    printf 'ERROR: this script supports Ubuntu only.\n' >&2
    exit 1
fi

# Make sure the target user exists on the remote host.
if ! id "$remote_user" >/dev/null 2>&1; then
    printf 'ERROR: remote user does not exist: %s\n' "$remote_user" >&2
    exit 1
fi

# Decode the public key that was embedded in the script.
public_key=$(printf '%s' "$public_key_b64" | base64 -d)
if [[ -z "$public_key" ]]; then
    printf 'ERROR: could not decode the supplied public key.\n' >&2
    exit 1
fi

# Update the system and install the base packages.
printf '\n===== System update =====\n'
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y full-upgrade
apt-get -y install --no-install-recommends \
    net-tools iftop unzip wget plocate nfs-common bat

# Turn on NTP and set the timezone.
printf '\n===== Timezone =====\n'
timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

# Define a helper that adds the custom bash prompt to a profile file.
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

# Find the user's home directory and set the prompt for the user and root.
IFS=: read -r _ _ _ _ _ user_home _ < <(getent passwd "$remote_user")
if [[ -z "$user_home" || ! -d "$user_home" ]]; then
    printf 'ERROR: could not find the home directory for %s.\n' "$remote_user" >&2
    exit 1
fi
configure_prompt "$user_home/.bashrc"
configure_prompt /root/.bashrc
chown "$remote_user:$(id -gn "$remote_user")" "$user_home/.bashrc"

# Disable the ufw firewall and SELinux.
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

# Disable IPv6 through sysctl.
printf '\n===== IPv6 =====\n'
cat > /etc/sysctl.d/99-prepubuntu11-disable-ipv6.conf <<'SYSCTL'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
SYSCTL
sysctl --system

# Give the user passwordless sudo and validate the sudoers file.
printf '\n===== Passwordless sudo =====\n'
sudoers_file="/etc/sudoers.d/90-prepubuntu11-${remote_user}"
printf '%s ALL=(ALL:ALL) NOPASSWD:ALL\n' "$remote_user" > "$sudoers_file"
chmod 0440 "$sudoers_file"
visudo -cf "$sudoers_file"

# Add the public key to authorized_keys for the user and root.
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

# Copy the private key into the user's ~/.ssh with safe permissions.
private_key_path="${user_home}/.ssh/${private_key_name}"
umask 077
printf '%s' "$private_key_b64" | base64 -d > "$private_key_path"
chown "$remote_user:$user_group" "$private_key_path"
chmod 0600 "$private_key_path"

# Allow root SSH login with keys only, and check the sshd config.
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
# Write a completion marker so the caller can confirm the run finished.
completion_marker="${user_home}/.prepubuntu11-${run_token}.complete"
: > "$completion_marker"
chown "$remote_user:$user_group" "$completion_marker"
chmod 0600 "$completion_marker"
# Reload sshd to apply the new configuration.
systemctl reload ssh

printf '\nUbuntu server preparation complete. Root SSH access is restricted to public-key authentication.\n'
REMOTE_SCRIPT
    }
}

# Prepare, upload, run and verify the setup on a single host.
run_for_host() {
    local server=$1
    local run_token="$$-${RANDOM}-${RANDOM}"
    local marker_name=".prepubuntu11-${run_token}.complete"
    local remote_status=0
    local marker_check

    # Connect to the host using the key or a password.
    printf '\n===== %s =====\n' "$server"
    connect_host "$server" || return 1

    # Dry run: report the plan and syntax-check the generated script, then stop.
    if (( dry_run )); then
        if [[ $conn_mode == key ]]; then
            printf '[dry-run] Would connect as %s with key %s.\n' "$conn_user" "$identity_file"
            printf '[dry-run] Would run setup via sudo (%s).\n' "$sudo_mode"
        else
            printf '[dry-run] Would connect with password and run setup via sudo -S.\n'
        fi
        if build_remote_script "${conn_user:-$remote_user}" "$run_token" | bash -n; then
            printf '[dry-run] Generated remote script passes syntax check.\n'
        else
            printf 'ERROR: generated remote script has syntax errors.\n' >&2
            return 1
        fi
        printf '[dry-run] Would upload ~/.prepubuntu11-remote.sh, then: apt update/full-upgrade + packages,\n'
        printf '          timezone America/Vancouver, bash prompts, disable ufw/SELinux/IPv6,\n'
        printf '          passwordless sudo for the user, install public key for user and root,\n'
        printf '          copy private key %s to the user ~/.ssh, set PermitRootLogin prohibit-password.\n' "$private_key_name"
        return 0
    fi

    # Command that checks for and removes the completion marker.
    marker_check="test -f \"\$HOME/${marker_name}\" && rm -f -- \"\$HOME/${marker_name}\""

    # Upload the generated setup script to the remote home directory.
    printf 'Uploading setup script as %s.\n' "$conn_user"
    build_remote_script "$conn_user" "$run_token" | remote_ssh "$server" "$upload_command" || return $?

    # Run the setup script with sudo (passwordless, or with the password on stdin).
    printf 'Running setup.\n'
    if [[ $sudo_mode == nopasswd ]]; then
        if remote_ssh "$server" "$remote_command_sudo_nopasswd" </dev/null; then
            remote_status=0
        else
            remote_status=$?
        fi
    else
        if printf '%s\n' "$remote_password" | remote_ssh "$server" "$remote_command_sudo_password"; then
            remote_status=0
        else
            remote_status=$?
        fi
    fi

    # Verify key login works for root and the user, and that the setup finished.
    if ssh "${key_ssh_options[@]}" -l root "$server" true && \
       ssh "${key_ssh_options[@]}" -l "$conn_user" "$server" "$marker_check"; then
        printf 'Setup completed and user/root key access verified on %s.\n' "$server"
        return 0
    fi

    printf 'ERROR: setup or key-access verification failed for %s (remote status %s).\n' "$server" "$remote_status" >&2
    return 1
}

# Run the setup on every host and record the ones that fail.
failed_servers=()
for server in "${servers[@]}"; do
    if ! run_for_host "$server"; then
        printf 'ERROR: setup failed for %s.\n' "$server" >&2
        failed_servers+=("$server")
    fi
done

# Report failed hosts and exit with an error.
if (( ${#failed_servers[@]} > 0 )); then
    printf 'Setup failed for: %s\n' "${failed_servers[*]}" >&2
    exit 1
fi

# Print the final summary.
if (( dry_run )); then
    printf '\nDry run completed for %d host(s); no changes were made.\n' "${#servers[@]}"
else
    printf '\nSetup completed successfully on all %d host(s).\n' "${#servers[@]}"
fi
