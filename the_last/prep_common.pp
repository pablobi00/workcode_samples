# Class: prep_common
#
# Purpose: Prepares a Linux server — CentOS 8 or Ubuntu — with the same
#          base packages, CLI tools, kernel settings, MySQL, and security
#          configuration. Puppet detects the OS and applies the correct
#          resource names and methods automatically.
#
# Required modules (install with 'puppet module install'):
#   - puppetlabs/stdlib   (provides the file_line resource)
#
# Supported OS:
#   - CentOS 8 / RHEL 8  ($facts['os']['family'] == 'RedHat')
#   - Ubuntu              ($facts['os']['family'] == 'Debian')
#
# Usage:
#   class { 'prep_common': admin_user => 'myuser' }

class prep_common (
  # Admin user that receives passwordless sudo and the custom bash prompt.
  String $admin_user = 'admin',
) {

  # ---------------------------------------------------------------------------
  # OS DETECTION
  # $facts['os']['family'] is set automatically by Puppet's Facter tool.
  # It returns 'RedHat' for CentOS/RHEL and 'Debian' for Ubuntu/Debian.
  # ---------------------------------------------------------------------------
  $os_family = $facts['os']['family']

  # ---------------------------------------------------------------------------
  # OS-SPECIFIC VARIABLES
  # The selector expression  ?{ }  picks the right value for each OS family.
  # Think of it like a switch statement that assigns a value to a variable.
  # ---------------------------------------------------------------------------

  # Which package manager Puppet should use on this OS
  $pkg_provider = $os_family ? {
    'RedHat' => 'yum',
    'Debian' => 'apt',
    default  => 'apt',
  }

  # Java package name differs between OS families
  $java_package = $os_family ? {
    'RedHat' => 'java-1.8.0-openjdk',      # CentOS name
    'Debian' => 'openjdk-8-jre-headless',  # Ubuntu name (headless = no GUI libs)
    default  => 'openjdk-8-jre-headless',
  }

  # NTP daemon service name differs between OS families
  $ntp_service_name = $os_family ? {
    'RedHat' => 'ntpd',  # CentOS: the daemon binary is ntpd
    'Debian' => 'ntp',   # Ubuntu: the systemd unit is named ntp
    default  => 'ntp',
  }

  # MySQL service name differs between OS families
  $mysql_service_name = $os_family ? {
    'RedHat' => 'mysqld',  # CentOS
    'Debian' => 'mysql',   # Ubuntu
    default  => 'mysql',
  }

  # SSH daemon service name differs between OS families
  $ssh_service_name = $os_family ? {
    'RedHat' => 'sshd',  # CentOS
    'Debian' => 'ssh',   # Ubuntu
    default  => 'ssh',
  }

  # Path to .bashrc for the custom prompt
  $bashrc_path = $os_family ? {
    'RedHat' => '/root/.bashrc',                    # CentOS: apply to root
    'Debian' => "/home/${admin_user}/.bashrc",      # Ubuntu: apply to admin user
    default  => "/home/${admin_user}/.bashrc",
  }

  # ===========================================================================
  # SECTION 1: Package Cache Update (Debian/Ubuntu only)
  # ===========================================================================

  # apt needs a cache refresh before installing packages.
  # This step does not apply to CentOS — yum manages its own cache automatically.
  if $os_family == 'Debian' {
    exec { 'apt_update':
      command => '/usr/bin/apt-get update',
      timeout => 300,
    }

    # This line creates an automatic ordering rule across ALL apt packages:
    # "always run apt_update before installing any package that uses apt".
    # The '<| |>' syntax is a Puppet resource collector — it matches all
    # Package resources where provider equals 'apt'.
    Exec['apt_update'] -> Package<| provider == 'apt' |>
  }

  # ===========================================================================
  # SECTION 2: Common Packages (same package name on both OS)
  # ===========================================================================

  # $pkg_provider selects 'yum' or 'apt' depending on the OS.
  # Note: nmon, bmon, and vnstat may require the EPEL repository on CentOS 8.
  #       Enable it with: yum install -y epel-release
  package { ['mlocate', 'unzip', 'wget', 'tmux', 'iftop', 'vim', 'gettext',
             'python3-pip', 'nmon', 'bmon', 'vnstat', 'ntp']:
    ensure   => installed,
    provider => $pkg_provider,
  }

  # ===========================================================================
  # SECTION 3: OS-Specific Packages
  # ===========================================================================

  if $os_family == 'RedHat' {
    # unix2dos: converts Windows (CRLF) line endings to Unix (LF) format
    # dnf: modern package manager included in CentOS 8+
    package { ['unix2dos', 'dnf']:
      ensure   => installed,
      provider => 'yum',
    }
  } elsif $os_family == 'Debian' {
    # cbm: colour bandwidth meter, available in Ubuntu's standard repos
    package { 'cbm':
      ensure   => installed,
      provider => 'apt',
    }
  }

  # ===========================================================================
  # SECTION 4: Java — OpenJDK 8
  # ===========================================================================

  # $java_package resolves to the correct package name for this OS.
  package { $java_package:
    ensure   => installed,
    provider => $pkg_provider,
  }

  # ===========================================================================
  # SECTION 5: NTP — Time Synchronisation
  # ===========================================================================

  # The 'ntp' package (declared in Section 2) is the same name on both OS.
  # The service name is different, so we use the $ntp_service_name variable.
  service { $ntp_service_name:
    ensure  => running,
    enable  => true,
    require => Package['ntp'],  # Wait for the package to be installed first
  }

  # Also register NTP with timedatectl (the OS-level clock manager).
  # 'unless' makes this idempotent — it skips the command if NTP is already on.
  exec { 'enable_ntp_timedatectl':
    command => '/usr/bin/timedatectl set-ntp true',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "NTP service: active"',
  }

  # ===========================================================================
  # SECTION 6: Timezone
  # ===========================================================================

  # Set the system timezone to America/Vancouver.
  # 'unless' makes this idempotent — it skips the command if already set.
  exec { 'set_timezone':
    command => '/usr/bin/timedatectl set-timezone America/Vancouver',
    unless  => '/usr/bin/timedatectl status | /usr/bin/grep -q "America/Vancouver"',
  }

  # ===========================================================================
  # SECTION 7: Custom Bash Prompt (PS1)
  # ===========================================================================

  # Append a coloured prompt showing date, time, user, host, and current path.
  # $bashrc_path points to the correct file for this OS and user.
  # file_line is idempotent: it adds the line only if it is not already present.
  file_line { 'custom_ps1_prompt':
    path => $bashrc_path,
    line => "PS1='\\[\\e[01;32m\\][\\[\\e[m\\]\\[\\e[01;32m\\]\\D{%Y.%m.%d}-\\A\\[\\e[m\\]\\[\\e[01;32m\\]]\\[\\e[m\\] \\[\\e[01;32m\\]\\u\\[\\e[m\\]\\[\\e[01;32m\\]@\\[\\e[m\\]\\[\\e[01;32m\\]\\h\\[\\e[m\\]:\\[\\e[36m\\]\\w\\[\\e[m\\] \\[\\e[32m\\]\\$\\[\\e[m\\] '",
  }

  # ===========================================================================
  # SECTION 8: MySQL Server
  # ===========================================================================

  # 'mysql-server' is the same package name on both CentOS 8 (AppStream) and Ubuntu.
  # Note: mysql_secure_installation is interactive and cannot be automated here.
  #       Run it manually after the first Puppet apply, or use the
  #       puppetlabs/mysql module for full automated MySQL configuration.
  package { 'mysql-server':
    ensure   => installed,
    provider => $pkg_provider,
  }

  # $mysql_service_name holds 'mysqld' (CentOS) or 'mysql' (Ubuntu).
  service { $mysql_service_name:
    ensure  => running,
    enable  => true,
    require => Package['mysql-server'],
  }

  # ===========================================================================
  # SECTION 9: Auto-Shutdown Cron Job
  # ===========================================================================

  # Schedule a daily shutdown at 19:05 for cloud cost management.
  # Puppet's cron resource manages the crontab entry directly — no temp files needed.
  cron { 'auto_shutdown':
    ensure  => present,
    command => '/usr/sbin/shutdown 0',
    user    => 'root',
    hour    => '19',
    minute  => '05',
  }

  # ===========================================================================
  # SECTION 10: Kernel Limits (open files and processes)
  # ===========================================================================

  # Drop-in file under limits.d/ — safer than editing limits.conf directly.
  # Files in limits.d/ are read after limits.conf and take precedence.
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
  # SECTION 11: Sysctl — Kernel Tuning
  # ===========================================================================

  # Drop-in sysctl file applied on both OS.
  #   vm.swappiness=10        : prefer keeping data in RAM rather than swap
  #   disable_ipv6 settings   : turn off IPv6 on all network interfaces
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

  # Apply the sysctl settings immediately when the file changes.
  # 'refreshonly' means this exec only runs when triggered by 'subscribe' —
  # not on every single Puppet run.
  exec { 'apply_sysctl':
    command     => '/usr/sbin/sysctl -p /etc/sysctl.d/99-custom.conf',
    subscribe   => File['/etc/sysctl.d/99-custom.conf'],
    refreshonly => true,
  }

  # ===========================================================================
  # SECTION 12: Firewall — Disable
  # ===========================================================================

  # CentOS uses firewalld; Ubuntu uses ufw. Each is handled separately.
  if $os_family == 'RedHat' {
    # Stop firewalld now and prevent it from starting again after a reboot.
    service { 'firewalld':
      ensure => stopped,
      enable => false,
    }
  } elsif $os_family == 'Debian' {
    # Disable ufw (Uncomplicated Firewall) on Ubuntu.
    # 'onlyif' prevents an error if ufw is already inactive.
    exec { 'disable_ufw':
      command => '/usr/sbin/ufw disable',
      onlyif  => '/usr/sbin/ufw status | /usr/bin/grep -q "Status: active"',
    }
  }

  # ===========================================================================
  # SECTION 13: SELinux — Disable (CentOS/RedHat only)
  # ===========================================================================

  # Ubuntu uses AppArmor by default, not SELinux, so this block is
  # RedHat-only. On CentOS, /etc/selinux/config is always present.
  if $os_family == 'RedHat' {
    # Put SELinux into permissive mode right now (takes effect without a reboot).
    # 'onlyif' prevents an error if it is already permissive or disabled.
    exec { 'setenforce_permissive':
      command => '/usr/sbin/setenforce 0',
      onlyif  => '/usr/sbin/getenforce | /usr/bin/grep -qi enforcing',
    }

    # Write SELINUX=disabled to the config file so the setting survives a reboot.
    # 'match' finds the existing SELINUX= line and replaces it with 'line'.
    file_line { 'disable_selinux_config':
      path  => '/etc/selinux/config',
      match => '^SELINUX=',
      line  => 'SELINUX=disabled',
    }
  }

  # ===========================================================================
  # SECTION 14: AWS CLI v2
  # ===========================================================================

  # The AWS CLI installer is the same on both OS (x86_64 Linux binary).

  # Download the installer zip. 'creates' skips this if the file already exists.
  exec { 'download_awscli':
    command => '/usr/bin/curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"',
    creates => '/tmp/awscliv2.zip',
    require => Package['unzip'],
  }

  # Unzip the archive into /tmp.
  exec { 'unzip_awscli':
    command => '/usr/bin/unzip -o /tmp/awscliv2.zip -d /tmp/',
    creates => '/tmp/aws',
    require => Exec['download_awscli'],
  }

  # Run the installer. 'creates' prevents reinstalling if aws binary already exists.
  exec { 'install_awscli':
    command => '/tmp/aws/install',
    creates => '/usr/local/bin/aws',
    require => Exec['unzip_awscli'],
  }

  # ===========================================================================
  # SECTION 15: Azure CLI
  # ===========================================================================

  # Azure CLI uses a yum repository on CentOS and a shell install script on Ubuntu.
  if $os_family == 'RedHat' {
    # Add the Microsoft yum repository so dnf can find the azure-cli package.
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

    # Install azure-cli after the repo file is in place.
    # 'require' ensures correct ordering: repo first, then install.
    package { 'azure-cli':
      ensure   => installed,
      provider => 'dnf',
      require  => File['/etc/yum.repos.d/azure-cli.repo'],
    }
  } elsif $os_family == 'Debian' {
    # Run Microsoft's official Debian/Ubuntu install script.
    # 'creates' prevents re-running if the az binary already exists.
    exec { 'install_azure_cli':
      command => '/bin/bash -c "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"',
      creates => '/usr/bin/az',
    }
  }

  # ===========================================================================
  # SECTION 16: Passwordless Sudo for Admin User
  # ===========================================================================

  # Drop-in sudoers file — safer than editing /etc/sudoers directly.
  # mode '0440': sudo requires this exact permission; not world-readable.
  file { "/etc/sudoers.d/${admin_user}":
    ensure  => file,
    mode    => '0440',
    content => "${admin_user} ALL=(ALL) NOPASSWD:ALL\n",
  }

  # ===========================================================================
  # SECTION 17: SSH Service
  # ===========================================================================

  # $ssh_service_name holds 'sshd' (CentOS) or 'ssh' (Ubuntu).
  # 'ensure => running' starts it if stopped; 'enable => true' starts it on boot.
  service { $ssh_service_name:
    ensure => running,
    enable => true,
  }

}
