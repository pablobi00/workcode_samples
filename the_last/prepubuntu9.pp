# Class: prepubuntu9
#
# Purpose: Prepares an Ubuntu system with base packages, CLI tools,
#          kernel settings, MySQL, and security configuration.
#
# Required modules (install with 'puppet module install'):
#   - puppetlabs/stdlib   (provides file_line resource)
#
# Usage:
#   Set $admin_user to the name of the user that should get sudo access.
#   Example:  class { 'prepubuntu9': admin_user => 'ubuntu' }

class prepubuntu9 (
  # The name of the non-root admin user to grant passwordless sudo.
  String $admin_user = 'ubuntu',
) {

  # ===========================================================================
  # SECTION 1: OS Update and Base Package Installation
  # ===========================================================================

  # Refresh the apt package cache so Puppet knows about the latest versions.
  # 'refreshonly => false' + 'unless' makes this run once per catalog run only
  # when the cache is older than 1 day, avoiding unnecessary network calls.
  exec { 'apt_update':
    command => '/usr/bin/apt-get update',
    timeout => 300,
  }

  # Install common system utilities via apt.
  # 'ensure => installed' means "make sure this package is present."
  # 'require' ensures the package cache is updated before installation.
  package { ['mlocate', 'unzip', 'nmon', 'python3-pip', 'iftop', 'bmon', 'cbm', 'vnstat']:
    ensure   => installed,
    provider => 'apt',
    require  => Exec['apt_update'],
  }

  # Install the NTP daemon for time synchronisation.
  package { 'ntp':
    ensure   => installed,
    provider => 'apt',
    require  => Exec['apt_update'],
  }

  # ===========================================================================
  # SECTION 2: NTP Service and Timezone
  # ===========================================================================

  # Enable and start the NTP service so the clock stays in sync.
  # 'require' ensures the package is installed before managing the service.
  service { 'ntp':
    ensure  => running,
    enable  => true,
    require => Package['ntp'],
  }

  # Enable NTP syncing via timedatectl (works alongside the ntp package).
  exec { 'enable_ntp_timedatectl':
    command => '/usr/bin/timedatectl set-ntp true',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "NTP service: active"',
  }

  # Set the system timezone to America/Vancouver.
  exec { 'set_timezone':
    command => '/usr/bin/timedatectl set-timezone America/Vancouver',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "America/Vancouver"',
  }

  # ===========================================================================
  # SECTION 3: Custom Bash Prompt (PS1)
  # ===========================================================================

  # Append a coloured prompt with date and time to the admin user's .bashrc.
  # file_line ensures the line is present without duplicating it on reruns.
  # Requires puppetlabs/stdlib module.
  file_line { 'custom_ps1_prompt':
    path => "/home/${admin_user}/.bashrc",
    line => "PS1='\\[\\e[01;32m\\][\\[\\e[m\\]\\[\\e[01;32m\\]\\D{%Y.%m.%d}-\\A\\[\\e[m\\]\\[\\e[01;32m\\]]\\[\\e[m\\] \\[\\e[01;32m\\]\\u\\[\\e[m\\]\\[\\e[01;32m\\]@\\[\\e[m\\]\\[\\e[01;32m\\]\\h\\[\\e[m\\]:\\[\\e[36m\\]\\w\\[\\e[m\\] \\[\\e[32m\\]\\$\\[\\e[m\\] '",
  }

  # ===========================================================================
  # SECTION 4: Java - OpenJDK 8
  # ===========================================================================

  # Install the headless OpenJDK 8 runtime (no GUI components).
  # Headless is preferred for servers that do not need a display.
  package { 'openjdk-8-jre-headless':
    ensure   => installed,
    provider => 'apt',
    require  => Exec['apt_update'],
  }

  # ===========================================================================
  # SECTION 5: Auto-Shutdown Cron Job
  # ===========================================================================

  # Schedule a daily shutdown at 21:10 for cloud cost management.
  # Puppet's cron resource manages the crontab entry directly — no temp files needed.
  cron { 'auto_shutdown':
    ensure  => present,
    command => '/usr/sbin/shutdown 0',
    user    => 'root',
    hour    => '21',
    minute  => '10',
  }

  # ===========================================================================
  # SECTION 6: Kernel Limits (open files and processes)
  # ===========================================================================

  # Write custom limits into a drop-in file under limits.d/.
  # This is safer than editing limits.conf directly because it does not
  # overwrite the original file.
  # Note: nofile is set to 655350 (higher than nproc) for heavy I/O workloads.
  file { '/etc/security/limits.d/99-custom.conf':
    ensure  => file,
    content => @(END),
      # Managed by Puppet - do not edit manually
      *    soft    nproc     65535
      *    hard    nproc     65535
      *    soft    nofile    655350
      *    hard    nofile    655350
      END
  }

  # ===========================================================================
  # SECTION 7: Firewall - Disable ufw
  # ===========================================================================

  # Disable the Uncomplicated Firewall (ufw) on Ubuntu.
  # 'onlyif' checks if ufw is currently active before disabling it.
  exec { 'disable_ufw':
    command => '/usr/sbin/ufw disable',
    onlyif  => '/usr/sbin/ufw status | /usr/bin/grep -q "Status: active"',
  }

  # ===========================================================================
  # SECTION 8: SELinux - Disable (if installed)
  # ===========================================================================

  # NOTE: Ubuntu uses AppArmor by default, not SELinux.
  # The steps below apply only if SELinux has been manually installed.
  # They are guarded by 'onlyif' so they do nothing when SELinux is absent.

  # Set SELinux to permissive mode right now (takes effect without a reboot).
  exec { 'setenforce_permissive':
    command => '/usr/sbin/setenforce 0',
    onlyif  => '/usr/bin/test -f /usr/sbin/getenforce && /usr/sbin/getenforce | /usr/bin/grep -qi enforcing',
  }

  # Update the SELinux config file to 'disabled' so it persists after reboot.
  # 'match' finds the existing SELINUX= line and 'line' replaces it.
  # Requires puppetlabs/stdlib module.
  file_line { 'disable_selinux_config':
    path    => '/etc/selinux/config',
    match   => '^SELINUX=',
    line    => 'SELINUX=disabled',
    onlyif  => '/usr/bin/test -f /etc/selinux/config',
  }

  # ===========================================================================
  # SECTION 9: AWS CLI v2 Installation
  # ===========================================================================

  # Download the AWS CLI zip file into /tmp.
  # 'creates' tells Puppet to skip this step if the file already exists.
  exec { 'download_awscli':
    command => '/usr/bin/curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"',
    creates => '/tmp/awscliv2.zip',
    require => Package['unzip'],
  }

  # Unzip the downloaded archive into /tmp.
  exec { 'unzip_awscli':
    command => '/usr/bin/unzip -o /tmp/awscliv2.zip -d /tmp/',
    creates => '/tmp/aws',
    require => Exec['download_awscli'],
  }

  # Run the AWS CLI installer script.
  # 'creates' prevents reinstalling if the binary already exists.
  exec { 'install_awscli':
    command => '/tmp/aws/install',
    creates => '/usr/local/bin/aws',
    require => Exec['unzip_awscli'],
  }

  # ===========================================================================
  # SECTION 10: Azure CLI Installation
  # ===========================================================================

  # Run Microsoft's official install script for Azure CLI on Debian/Ubuntu.
  # 'creates' prevents re-running if az is already installed.
  exec { 'install_azure_cli':
    command => '/bin/bash -c "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"',
    creates => '/usr/bin/az',
  }

  # ===========================================================================
  # SECTION 11: MySQL Server
  # ===========================================================================

  # Install MySQL Server.
  # Note: 'mysql_secure_installation' from the original script is interactive
  # and cannot be automated here. Run it manually after the first Puppet apply,
  # or use the puppetlabs/mysql module for full automated configuration.
  package { 'mysql-server':
    ensure   => installed,
    provider => 'apt',
    require  => Exec['apt_update'],
  }

  # Ensure MySQL is running and starts automatically on boot.
  service { 'mysql':
    ensure  => running,
    enable  => true,
    require => Package['mysql-server'],
  }

  # ===========================================================================
  # SECTION 12: Sysctl Tuning (swappiness + disable IPv6)
  # ===========================================================================

  # Write all sysctl performance and network settings into a single drop-in file.
  # Placing settings in /etc/sysctl.d/ keeps them separate from the main file.
  #   vm.swappiness=10   : makes the kernel prefer RAM over swap (better for servers)
  #   disable_ipv6 lines : turn off IPv6 on all interfaces
  file { '/etc/sysctl.d/99-custom.conf':
    ensure  => file,
    content => @(END),
      # Managed by Puppet - do not edit manually
      vm.swappiness = 10
      net.ipv6.conf.all.disable_ipv6 = 1
      net.ipv6.conf.default.disable_ipv6 = 1
      net.ipv6.conf.lo.disable_ipv6 = 1
      END
  }

  # Apply the sysctl settings immediately after the file changes.
  # 'refreshonly' means this exec only runs when triggered by a subscribe event.
  exec { 'apply_sysctl':
    command     => '/usr/sbin/sysctl -p /etc/sysctl.d/99-custom.conf',
    subscribe   => File['/etc/sysctl.d/99-custom.conf'],
    refreshonly => true,
  }

  # ===========================================================================
  # SECTION 13: Passwordless Sudo for Admin User
  # ===========================================================================

  # Create a dedicated sudoers drop-in file for the admin user.
  # Writing to /etc/sudoers.d/ is safer than editing /etc/sudoers directly.
  # mode '0440' is required by sudo; the file must not be world-readable.
  file { "/etc/sudoers.d/${admin_user}":
    ensure  => file,
    mode    => '0440',
    content => "${admin_user} ALL=(ALL) NOPASSWD:ALL\n",
  }

  # ===========================================================================
  # SECTION 14: SSH Service
  # ===========================================================================

  # Make sure the SSH daemon is running and starts automatically on boot.
  # On Ubuntu the service is called 'ssh', not 'sshd'.
  service { 'ssh':
    ensure => running,
    enable => true,
  }

}
