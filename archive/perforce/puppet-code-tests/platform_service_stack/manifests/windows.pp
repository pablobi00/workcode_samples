# This class manages the Windows Server branch of the service stack.
# It deploys IIS and Microsoft SQL Server.
class platform_service_stack::windows (
  # These values come from Hiera so Windows environments can supply installer details.
  String $iis_feature                  = lookup('platform_service_stack::windows::iis_feature', { default_value => $platform_service_stack::params::iis_feature }),
  String $iis_service                  = lookup('platform_service_stack::windows::iis_service', { default_value => $platform_service_stack::params::iis_service }),
  String $sql_package_name             = lookup('platform_service_stack::windows::sql_package_name', { default_value => $platform_service_stack::params::sql_package_name }),
  String $sql_service                  = lookup('platform_service_stack::windows::sql_service', { default_value => $platform_service_stack::params::sql_service }),
  String $sql_source                   = lookup('platform_service_stack::windows::sql_source'),
  Array[String] $sql_install_options   = lookup('platform_service_stack::windows::sql_install_options', { default_value => [
    '/Q',
    '/ACTION=Install',
    '/FEATURES=SQLENGINE',
    '/INSTANCENAME=MSSQLSERVER',
    '/IACCEPTSQLSERVERLICENSETERMS',
  ] }),
) inherits platform_service_stack::params {

  # Fail early if this class is included on a non-Windows system.
  if $facts['os']['family'] != 'windows' {
    fail("platform_service_stack::windows only supports Windows, but found ${facts['os']['name']}.")
  }

  # Install the IIS feature by using the Windows feature provider.
  package { $iis_feature:
    ensure   => installed,
    provider => windowsfeature,
  }

  # Install Microsoft SQL Server from the installer path defined in Hiera.
  package { $sql_package_name:
    ensure          => installed,
    source          => $sql_source,
    install_options => $sql_install_options,
  }

  # Ensure the IIS service is enabled and running.
  service { $iis_service:
    ensure  => running,
    enable  => true,
    require => Package[$iis_feature],
  }

  # Ensure the SQL Server service is enabled and running.
  service { $sql_service:
    ensure  => running,
    enable  => true,
    require => Package[$sql_package_name],
  }
}
