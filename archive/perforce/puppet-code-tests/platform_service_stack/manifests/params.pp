# This class resolves operating-system-specific defaults for the service stack.
# The linux and windows classes inherit these values to keep the logic simple.
class platform_service_stack::params {

  # Set Linux package and service names for RedHat-family systems.
  if $facts['os']['family'] == 'RedHat' {
    $apache_package   = 'httpd'
    $apache_service   = 'httpd'
    $time_package     = 'chrony'
    $time_service     = 'chronyd'
    $database_package = 'mariadb-server'
    $database_service = 'mariadb'

  # Set Linux package and service names for Ubuntu.
  } elsif $facts['os']['family'] == 'Debian' and $facts['os']['name'] == 'Ubuntu' {
    $apache_package   = 'apache2'
    $apache_service   = 'apache2'
    $time_package     = 'chrony'
    $time_service     = 'chrony'
    $database_package = 'mariadb-server'
    $database_service = 'mariadb'

  # Set Windows feature and service names for Windows Server systems.
  } elsif $facts['os']['family'] == 'windows' {
    $iis_feature      = 'Web-Server'
    $iis_service      = 'W3SVC'
    $sql_package_name = lookup('platform_service_stack::windows::sql_package_name', { default_value => 'SQL Server 2022 Database Engine' })
    $sql_service      = lookup('platform_service_stack::windows::sql_service', { default_value => 'MSSQLSERVER' })

  # Fail clearly if the operating system is not supported.
  } else {
    fail("platform_service_stack::params does not support ${facts['os']['family']} on ${facts['os']['name']}.")
  }
}
