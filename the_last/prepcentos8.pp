# Class: prepcentos8
#
# Purpose: Prepares a CentOS 8 system with base packages, CLI tools,
#          kernel settings, and security configuration.
#
# Required modules (install with 'puppet module install'):
#   - puppetlabs/stdlib   (provides file_line resource)
#
# Usage:
#   Set $admin_user to the name of the user that should get sudo access.
#   Example:  class { 'prepcentos8': admin_user => 'deploy' }

class prepcentos8 (
  # The name of the non-root admin user to grant passwordless sudo.
  String $admin_user = 'deploy',
) {

  # ===========================================================================
  # SECTION 1: Base Package Installation
  # ===========================================================================

  # Install common system utilities using yum.
  # 'ensure => installed' means "make sure this package is present."
  package { ['mlocate', 'unzip', 'wget', 'tmux', 'iftop', 'vim', 'gettext', 'unix2dos', 'dnf']:
    ensure   => installed,
    provider => 'yum',
  }

  # Install OpenJDK 8 (Java runtime environment).
  package { 'java-1.8.0-openjdk':
    ensure   => installed,
    provider => 'yum',
  }

  # ===========================================================================
  # SECTION 2: Custom Bash Prompt (PS1)
  # ===========================================================================

  # Append a coloured prompt with date and time to root's .bashrc.
  # file_line ensures the line is present without duplicating it on reruns.
  # Requires puppetlabs/stdlib module.
  file_line { 'custom_ps1_prompt':
    path => '/root/.bashrc',
    line => "PS1='\\[\\e[01;32m\\][\\[\\e[m\\]\\[\\e[01;32m\\]\\D{%Y.%m.%d}-\\A\\[\\e[m\\]\\[\\e[01;32m\\]]\\[\\e[m\\] \\[\\e[01;32m\\]\\u\\[\\e[m\\]\\[\\e[01;32m\\]@\\[\\e[m\\]\\[\\e[01;32m\\]\\h\\[\\e[m\\]:\\[\\e[36m\\]\\w\\[\\e[m\\] \\[\\e[32m\\]\\$\\[\\e[m\\] '",
  }

  # ===========================================================================
  # SECTION 3: Timezone Configuration
  # ===========================================================================

  # Enable NTP (automatic time sync) if it is not already active.
  # 'unless' prevents the command from running if NTP is already on.
  exec { 'enable_ntp':
    command => '/usr/bin/timedatectl set-ntp true',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "NTP service: active"',
  }

  # Set the system timezone to America/Vancouver.
  # 'unless' skips the command if the timezone is already correct.
  exec { 'set_timezone':
    command => '/usr/bin/timedatectl set-timezone America/Vancouver',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "America/Vancouver"',
  }

  # ===========================================================================
  # SECTION 4: AWS CLI v2 Installation
  # ===========================================================================

  # Download the AWS CLI zip file into /tmp.
  # 'creates' tells Puppet to skip this step if the file already exists.
  exec { 'download_awscli':
    command => '/usr/bin/curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"',
    creates => '/tmp/awscliv2.zip',
    require => Package['unzip'],
  }

  # Unzip the downloaded archive.
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
  # SECTION 5: Azure CLI Repository and Installation
  # ===========================================================================

  # Create the yum repository file so dnf knows where to find Azure CLI.
  # 'ensure => file' means create a regular file (not a directory).
  file { '/etc/yum.repos.d/azure-cli.repo':
    ensure  => file,
    content => @("END"),
      [azure-cli]
      name=Azure CLI
      baseurl=https://packages.microsoft.com/yumrepos/azure-cli
      enabled=1
      gpgcheck=1
      gpgkey=https://packages.microsoft.com/keys/microsoft.asc
      | END
  }

  # Install Azure CLI after the repository file is in place.
  # 'require' sets the order: repo file must exist before installation.
  package { 'azure-cli':
    ensure   => installed,
    provider => 'dnf',
    require  => File['/etc/yum.repos.d/azure-cli.repo'],
  }

  # ===========================================================================
  # SECTION 6: Auto-Shutdown Cron Job
  # ===========================================================================

  # Schedule a daily shutdown at 19:05 for cloud cost management.
  # Puppet's cron resource manages the crontab entry directly.
  cron { 'auto_shutdown':
    ensure  => present,
    command => '/usr/sbin/shutdown 0',
    user    => 'root',
    hour    => '19',
    minute  => '05',
  }

  # ===========================================================================
  # SECTION 7: Kernel Limits (open files and processes)
  # ===========================================================================

  # Write custom limits into its own drop-in file under limits.d/.
  # This is safer than editing limits.conf directly because it does not
  # overwrite the original file.
  file { '/etc/security/limits.d/99-custom.conf':
    ensure  => file,
    content => @(END),
      # Managed by Puppet - do not edit manually
      *    soft    nproc     65535
      *    hard    nproc     65535
      *    soft    nofile    65535
      *    hard    nofile    65535
      END
  }

  # ===========================================================================
  # SECTION 8: Disable IPv6 via sysctl
  # ===========================================================================

  # Write IPv6 disable settings into a sysctl drop-in file.
  # Placing settings in /etc/sysctl.d/ keeps them separate from the main file.
  file { '/etc/sysctl.d/99-disable-ipv6.conf':
    ensure  => file,
    content => @(END),
      # Managed by Puppet - do not edit manually
      net.ipv6.conf.all.disable_ipv6 = 1
      net.ipv6.conf.default.disable_ipv6 = 1
      net.ipv6.conf.lo.disable_ipv6 = 1
      END
  }

  # Apply the sysctl settings immediately after the file changes.
  # 'subscribe' means: only run this exec when the file above is updated.
  # 'refreshonly' means: never run unless triggered by a subscribe event.
  exec { 'apply_sysctl':
    command     => '/usr/sbin/sysctl -p /etc/sysctl.d/99-disable-ipv6.conf',
    subscribe   => File['/etc/sysctl.d/99-disable-ipv6.conf'],
    refreshonly => true,
  }

  # ===========================================================================
  # SECTION 9: Firewall - Disable firewalld
  # ===========================================================================

  # Stop firewalld now and prevent it from starting on boot.
  # 'ensure => stopped' turns it off immediately.
  # 'enable => false' stops it from starting automatically after a reboot.
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  # ===========================================================================
  # SECTION 10: SELinux - Disable
  # ===========================================================================

  # Set SELinux to permissive mode right now (takes effect without a reboot).
  # 'onlyif' prevents an error if SELinux is already permissive or disabled.
  exec { 'setenforce_permissive':
    command => '/usr/sbin/setenforce 0',
    onlyif  => '/usr/sbin/getenforce | /usr/bin/grep -qi enforcing',
  }

  # Update the SELinux config file to 'disabled' so it persists after reboot.
  # 'match' finds the existing SELINUX= line and 'line' replaces it.
  # Requires puppetlabs/stdlib module.
  file_line { 'disable_selinux_config':
    path  => '/etc/selinux/config',
    match => '^SELINUX=',
    line  => 'SELINUX=disabled',
  }

  # ===========================================================================
  # SECTION 11: Passwordless Sudo for Admin User
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
  # SECTION 12: SSH Service
  # ===========================================================================

  # Make sure the SSH daemon is running and starts automatically on boot.
  # 'ensure => running' starts it now if it is stopped.
  # 'enable => true' registers it to start on every reboot.
  service { 'sshd':
    ensure => running,
    enable => true,
  }

}
