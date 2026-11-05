# This class manages the Linux branch of the service stack.
# It deploys Apache, Chrony, and MariaDB on RHEL or Ubuntu systems.
class platform_service_stack::linux (
  # These values come from Hiera so the class is easy to customize per environment.
  String $apache_package   = lookup('platform_service_stack::linux::apache_package', { default_value => $platform_service_stack::params::apache_package }),
  String $apache_service   = lookup('platform_service_stack::linux::apache_service', { default_value => $platform_service_stack::params::apache_service }),
  String $time_package     = lookup('platform_service_stack::linux::time_package', { default_value => $platform_service_stack::params::time_package }),
  String $time_service     = lookup('platform_service_stack::linux::time_service', { default_value => $platform_service_stack::params::time_service }),
  String $database_package = lookup('platform_service_stack::linux::database_package', { default_value => $platform_service_stack::params::database_package }),
  String $database_service = lookup('platform_service_stack::linux::database_service', { default_value => $platform_service_stack::params::database_service }),
) inherits platform_service_stack::params {

  # Fail early if this class is included on an unsupported Linux platform.
  if !($facts['os']['family'] == 'RedHat' or ($facts['os']['family'] == 'Debian' and $facts['os']['name'] == 'Ubuntu')) {
    fail("platform_service_stack::linux supports RHEL-family systems and Ubuntu, but found ${facts['os']['name']}.")
  }

  # Install the Apache package for the current Linux platform.
  package { $apache_package:
    ensure => installed,
  }

  # Install the Chrony package for time synchronization.
  package { $time_package:
    ensure => installed,
  }

  # Install the MariaDB server package.
  package { $database_package:
    ensure => installed,
  }

  # Ensure the Apache service is enabled and running.
  service { $apache_service:
    ensure  => running,
    enable  => true,
    require => Package[$apache_package],
  }

  # Ensure the time synchronization service is enabled and running.
  service { $time_service:
    ensure  => running,
    enable  => true,
    require => Package[$time_package],
  }

  # Ensure the MariaDB service is enabled and running.
  service { $database_service:
    ensure  => running,
    enable  => true,
    require => Package[$database_package],
  }
}
