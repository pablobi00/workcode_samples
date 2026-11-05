# @summary Installs base packages, manages time sync, and deploys MOTD scripts.
#   Defaults come from profile::params; all values are overridable via Hiera.
class profile::motd (
  Array[String[1]]     $packages       = $profile::params::packages,
  String[1]            $chrony_package = $profile::params::chrony_package,
  String[1]            $chrony_service = $profile::params::chrony_service,
  Stdlib::Filesource   $motd_source    = $profile::params::motd_source,
  Stdlib::Absolutepath $motd_dir       = $profile::params::motd_dir,
  String[1]            $motd_owner     = $profile::params::motd_owner,
  String[1]            $motd_group     = $profile::params::motd_group,
  Stdlib::Filemode     $motd_mode      = $profile::params::motd_mode,
) inherits profile::params {

  package { $packages:
    ensure => installed,
  }

  if $facts['os']['name'] == 'Rocky' {
    package { $chrony_package:
      ensure => installed,
    }

    service { $chrony_service:
      ensure  => running,
      enable  => true,
      require => Package[$chrony_package],
    }
  } else {
    include ntp
  }

  file { $motd_dir:
    ensure  => directory,
    owner   => $motd_owner,
    group   => $motd_group,
    mode    => $motd_mode,
    recurse => true,
    source  => $motd_source,
  }
}
