# @summary Manages MOTD packages, NTP service, and MOTD files
#
# Installs required packages, configures NTP (chrony on Rocky Linux,
# ntp via Puppet Forge otherwise), and deploys MOTD scripts.
#
class profile::motd {

  # -----------------------------------------------------------------
  # Packages
  # -----------------------------------------------------------------
  Array[String[1]] $packages = [
    'bzip2',
    'update-motd',
    'figlet',
    'lolcat',
    'hddtemp',
  ]

  package { $packages:
    ensure => installed,
  }

  # -----------------------------------------------------------------
  # NTP
  # -----------------------------------------------------------------
  if $facts['os']['name'] == 'Rocky' {

    package { 'chrony':
      ensure => installed,
    }

    service { 'chronyd':
      ensure  => running,
      enable  => true,
      require => Package['chrony'],
    }

  } else {

    class { 'ntp': }

  }

  # -----------------------------------------------------------------
  # MOTD files
  # -----------------------------------------------------------------
  file { '/etc/update-motd.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/profile/motd',
    require => Package[$packages],
  }

}
