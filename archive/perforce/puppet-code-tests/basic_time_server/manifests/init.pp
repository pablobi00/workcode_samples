class basic_time_server {

  # Supported operating systems for this class.
  $supported_os = {
    'Rocky'     => true,
    'AlmaLinux' => true,
  }

  if !has_key($supported_os, $facts['os']['name']) {
    fail("basic_time_server only supports Rocky and AlmaLinux, but found ${facts['os']['name']}")
  }

  # Use Puppet Forge modules to install and manage the packages.
  # Apache HTTPD, MariaDB server, and Chrony are the target components.
  class { 'apache': }
  class { 'mysql::server': }
  class { 'chrony': }

  # Ensure the services are enabled and running on supported systems.
  service { ['httpd', 'mariadb', 'chronyd']:
    ensure => running,
    enable => true,
    require => [Class['apache'], Class['mysql::server'], Class['chrony']],
  }
}
