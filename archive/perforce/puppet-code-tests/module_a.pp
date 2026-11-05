# Puppet module for webservers group on AlmaLinux
class module_a (
  String $group_name = 'webservers',
) {
  # Identify AlmaLinux servers and add them to the webservers node group
  if $facts['os']['name'] == 'AlmaLinux' {
    notice("Node ${trusted['certname']} is running AlmaLinux - adding to ${group_name} group")
  } else {
    fail("This module only supports AlmaLinux. Detected OS: ${facts['os']['name']}")
  }

  # Assign group
  notice("Setting up ${group_name} group")

  # Install required packages
  package { ['httpd', 'ntp', 'mysql-server']:
    ensure => installed,
  }

  # Start and enable Apache
  service { 'httpd':
    ensure    => running,
    enable    => true,
    require   => Package['httpd'],
  }

  # Start and enable NTP
  service { 'ntpd':
    ensure    => running,
    enable    => true,
    require   => Package['ntp'],
  }

  # Start and enable MySQL
  service { 'mysqld':
    ensure    => running,
    enable    => true,
    require   => Package['mysql-server'],
  }
}
