#!/bin/bash
set -euo pipefail

USERNOWNAME='ubuntu'
USER_HOME="/home/${USERNOWNAME}"

# Require root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: run this script as root" >&2
    exit 1
fi

# ===== [OS Tools and update] =============================================
printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

apt-get -y update
apt-get -y full-upgrade
apt-get -y install --no-install-recommends \
    unzip nmon iftop bmon cbm vnstat net-tools network-manager

# AWS CLI
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp/awscli
/tmp/awscli/aws/install
aws --version
rm -rf /tmp/awscliv2.zip /tmp/awscli

# ===== [OS Parameters/Configuration] =====================================
printf "\e[0;36m\n===== [ OS Parameters/Configuration ] ===========================\n\e[0m"

# Timezone
timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

# PS1 for the ubuntu user (green prompt)
grep -qxF "PS1='\\[\\e[01;32m\\]" "${USER_HOME}/.bashrc" 2>/dev/null || \
    echo "PS1='\[\e[01;32m\][\[\e[m\]\[\e[01;32m\]\D{%Y.%m.%d}-\A\[\e[m\]\[\e[01;32m\]]\[\e[m\] \[\e[01;32m\]\u\[\e[m\]\[\e[01;32m\]@\[\e[m\]\[\e[01;32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\] \[\e[32m\]\\$\[\e[m\] '" \
    >> "${USER_HOME}/.bashrc"

# PS1 for root (red prompt to signal elevated privileges)
grep -qxF "PS1='\\[\\e[01;31m\\]" /root/.bashrc 2>/dev/null || \
    echo "PS1='\[\e[01;31m\][\[\e[m\]\[\e[01;31m\]\D{%Y.%m.%d}-\A\[\e[m\]\[\e[01;31m\]]\[\e[m\] \[\e[01;31m\]\u\[\e[m\]\[\e[01;31m\]@\[\e[m\]\[\e[01;31m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\] \[\e[31m\]\\$\[\e[m\] '" \
    >> /root/.bashrc



# Auto-shutdown cron (21:10 daily)
( crontab -l 2>/dev/null | grep -v 'sudo shutdown'; echo "10 21 * * * sudo shutdown 0" ) | crontab -

# ===== [Firewall] =========================================================
printf '\e[0;36m\n===== [Firewall] =========================\n\e[0m'

ufw disable

# SELinux (skip gracefully — Ubuntu uses AppArmor, not SELinux)
if command -v setenforce &>/dev/null; then
    setenforce 0
    [[ -f /etc/selinux/config ]] && sed -i 's/SELINUX=enabled/SELINUX=disabled/g' /etc/selinux/config
fi

# ===== [Networking] =======================================================
printf "\e[31m\n===== [Networking] =============\n\e[0m"

# Disable IPv6
cat >> /etc/sysctl.conf <<'EOL'
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
EOL
sysctl -p

# Passwordless sudo
printf "%s ALL=(ALL) NOPASSWD:ALL\n" "${USERNOWNAME}" > "/etc/sudoers.d/${USERNOWNAME}"
chmod 0440 "/etc/sudoers.d/${USERNOWNAME}"

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"
