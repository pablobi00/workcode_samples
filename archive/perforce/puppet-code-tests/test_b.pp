# Puppet manifest to deploy WordPress with dependencies on AlmaLinux

class wordpress_deployment {
  
  # Update package manager
  exec { 'yum_update':
  command => '/usr/bin/yum update -y',
  }

  # Install Apache, PHP, and MySQL
  package { ['httpd', 'php', 'php-mysql', 'php-gd', 'php-xml', 'mysql-server', 'git', 'wget']:
  ensure  => installed,
  require => Exec['yum_update'],
  }

  # Start and enable services
  service { ['httpd', 'mysqld']:
  ensure  => running,
  enable  => true,
  require => Package['httpd', 'mysql-server'],
  }

  # Create WordPress database directory
  file { '/var/www/html/wordpress':
  ensure  => directory,
  owner   => 'apache',
  group   => 'apache',
  mode    => '0755',
  require => Package['httpd'],
  }

  # Download and extract WordPress
  exec { 'download_wordpress':
  command => '/usr/bin/wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && /bin/tar -xzf /tmp/wordpress.tar.gz -C /var/www/html/',
  require => [Package['wget'], File['/var/www/html/wordpress']],
  creates => '/var/www/html/wordpress/wp-config.php',
  }

  # Set WordPress ownership
  exec { 'set_wordpress_perms':
  command => '/bin/chown -R apache:apache /var/www/html/wordpress && /bin/chmod -R 755 /var/www/html/wordpress',
  require => Exec['download_wordpress'],
  }

  # Create MySQL database and user
  exec { 'create_wordpress_db':
  command => "/usr/bin/mysql -e 'CREATE DATABASE wordpress; CREATE USER \"wordpress\"@\"localhost\" IDENTIFIED BY \"password\"; GRANT ALL PRIVILEGES ON wordpress.* TO \"wordpress\"@\"localhost\"; FLUSH PRIVILEGES;'",
  require => Service['mysqld'],
  }

  # Configure WordPress wp-config.php
  file { '/var/www/html/wordpress/wp-config.php':
  ensure  => present,
  owner   => 'apache',
  group   => 'apache',
  mode    => '0644',
  require => Exec['download_wordpress'],
  }
}

include wordpress_deployment
