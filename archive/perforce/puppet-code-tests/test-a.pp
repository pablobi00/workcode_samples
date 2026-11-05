# Class to manage packages, time synchronization, and MOTD configuration
class profile::packages (
  Array[String] $base_packages = [
    'bzip2',
    'update-motd',
    'figlet',
    'lolcat',
    'hddtemp',
  ],
  String $motd_source = 'puppet:///modules/profile/motd',
  String $motd_target = '/etc/update-motd.d',
  String $motd_owner = 'root',
  String $motd_group = 'root',
  String $motd_mode = '0755',
) {
  # Install base packages
  ensure_packages($base_packages, { 'ensure' => 'present' })

  # Time synchronization based on OS
  if $facts['os']['name'] == 'Rocky' {
    # Install and enable chrony on Rocky Linux
    package { 'chrony':
      ensure => present,
    }

    service { 'chronyd':
      ensure  => running,
      enable  => true,
      require => Package['chrony'],
    }
  } else {
    # Install ntp using Puppet Forge module for other OSes
    class { 'ntp': }
  }

  # Manage MOTD files
  file { $motd_target:
    ensure  => directory,
    source  => $motd_source,
    owner   => $motd_owner,
    group   => $motd_group,
    mode    => $motd_mode,
    recurse => true,
    require => Package['update-motd'],
  }
}
