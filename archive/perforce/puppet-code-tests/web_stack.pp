# web_stack.pp
#
# Cross-platform Puppet manifest for managing Apache and MySQL
# Supports: Ubuntu (Debian family) and RHEL/CentOS (RedHat family)
#
# Requires:
#   puppetlabs-apache  >= 6.0.0
#   puppetlabs-mysql   >= 12.0.0
#
# Usage:
#   Apply to a node:  puppet apply web_stack.pp
#   Via Puppet server: include the appropriate node block below

# ===========================================================================
# CLASS: web_stack::params
# OS-specific parameter resolution — inherited by apache and mysql classes
# ===========================================================================
class web_stack::params {
  case $facts['os']['family'] {
    'Debian': {
      # Ubuntu / Debian
      $apache_package  = 'apache2'
      $apache_service  = 'apache2'
      $apache_conf_dir = '/etc/apache2'
      $apache_log_dir  = '/var/log/apache2'
      $apache_user     = 'www-data'
      $apache_group    = 'www-data'
      $apache_vhost_dir = '/etc/apache2/sites-available'

      $mysql_package   = 'mysql-server'
      $mysql_service   = 'mysql'
      $mysql_conf_dir  = '/etc/mysql/conf.d'
    }
    'RedHat': {
      # RHEL / CentOS / Rocky / AlmaLinux
      $apache_package  = 'httpd'
      $apache_service  = 'httpd'
      $apache_conf_dir = '/etc/httpd'
      $apache_log_dir  = '/var/log/httpd'
      $apache_user     = 'apache'
      $apache_group    = 'apache'
      $apache_vhost_dir = '/etc/httpd/conf.d'

      $mysql_package   = 'mysql-server'
      $mysql_service   = 'mysqld'
      $mysql_conf_dir  = '/etc/my.cnf.d'
    }
    default: {
      fail("Unsupported OS family '${facts['os']['family']}'. This manifest supports Debian and RedHat families only.")
    }
  }
}

# ===========================================================================
# CLASS: web_stack::apache
# Installs and configures Apache with optional virtual hosts
#
# Parameters:
#   docroot        - Default document root directory
#   server_name    - Primary ServerName value
#   http_port      - HTTP listening port (default: 80)
#   ssl_port       - HTTPS listening port (default: 443)
#   vhosts         - Hash of virtual host definitions
# ===========================================================================
class web_stack::apache (
  String           $docroot     = '/var/www/html',
  String           $server_name = $facts['networking']['fqdn'],
  Integer          $http_port   = 80,
  Integer          $ssl_port    = 443,
  Hash             $vhosts      = {},
) inherits web_stack::params {

  # --- Package ---
  package { $web_stack::params::apache_package:
    ensure => installed,
  }

  # --- Service ---
  service { $web_stack::params::apache_service:
    ensure    => running,
    enable    => true,
    subscribe => Package[$web_stack::params::apache_package],
  }

  # --- Default document root ---
  file { $docroot:
    ensure  => directory,
    owner   => $web_stack::params::apache_user,
    group   => $web_stack::params::apache_group,
    mode    => '0755',
    require => Package[$web_stack::params::apache_package],
  }

  # --- Default index page (only if docroot is newly created) ---
  file { "${docroot}/index.html":
    ensure  => present,
    owner   => $web_stack::params::apache_user,
    group   => $web_stack::params::apache_group,
    mode    => '0644',
    content => "<html><body><h1>Managed by Puppet on ${facts['hostname']}</h1></body></html>\n",
    replace => false,   # do not overwrite if already present
    require => File[$docroot],
  }

  # --- Virtual hosts (uses puppetlabs-apache module) ---
  $vhosts.each |String $vhost_name, Hash $vhost_config| {
    apache::vhost { $vhost_name:
      port    => $vhost_config.get('port', $http_port),
      docroot => $vhost_config.get('docroot', "${docroot}/${vhost_name}"),
      *       => $vhost_config,
    }
  }

  # --- Log directory (RHEL does not create it automatically) ---
  if $facts['os']['family'] == 'RedHat' {
    file { $web_stack::params::apache_log_dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      require => Package[$web_stack::params::apache_package],
      before  => Service[$web_stack::params::apache_service],
    }
  }
}

# ===========================================================================
# CLASS: web_stack::mysql
# Installs and configures MySQL server, databases, and users
#
# Parameters:
#   root_password           - MySQL root password (use Hiera for production)
#   remove_default_accounts - Drop anonymous accounts and test DB (default: true)
#   bind_address            - Interface MySQL listens on (default: 127.0.0.1)
#   max_connections         - Max simultaneous connections (default: 151)
#   databases               - Hash of databases to create (see example below)
#
# Example $databases value:
#   {
#     'myapp_db' => {
#       user     => 'myapp_user',
#       password => 'secret',
#       host     => 'localhost',
#       grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
#     }
#   }
# ===========================================================================
class web_stack::mysql (
  String  $root_password           = 'CHANGE_ME_IN_HIERA',
  Boolean $remove_default_accounts = true,
  String  $bind_address            = '127.0.0.1',
  Integer $max_connections         = 151,
  Hash    $databases               = {},
) inherits web_stack::params {

  # --- MySQL server (puppetlabs-mysql module) ---
  class { 'mysql::server':
    root_password           => $root_password,
    remove_default_accounts => $remove_default_accounts,
    override_options        => {
      'mysqld' => {
        'bind-address'   => $bind_address,
        'max_connections' => $max_connections,
        'log_error'      => '/var/log/mysql/error.log',
        'slow_query_log' => 'ON',
        'long_query_time' => 2,
      },
    },
  }

  # --- Log directory ---
  file { '/var/log/mysql':
    ensure  => directory,
    owner   => 'mysql',
    group   => 'mysql',
    mode    => '0750',
    require => Class['mysql::server'],
  }

  # --- Databases and users ---
  $databases.each |String $db_name, Hash $db_config| {
    mysql::db { $db_name:
      user     => $db_config['user'],
      password => $db_config['password'],
      host     => $db_config.get('host', 'localhost'),
      grant    => $db_config.get('grant', ['ALL']),
      charset  => $db_config.get('charset', 'utf8mb4'),
      collate  => $db_config.get('collate', 'utf8mb4_unicode_ci'),
      require  => Class['mysql::server'],
    }
  }
}

# ===========================================================================
# NODE DEFINITIONS
# Match nodes by hostname pattern or FQDN
# ===========================================================================

# --- Ubuntu web servers ---
node /^(web|app)-ubuntu/ {
  class { 'web_stack::apache':
    server_name => $facts['networking']['fqdn'],
    docroot     => '/var/www/html',
    vhosts      => {
      'app.example.com' => {
        port    => 80,
        docroot => '/var/www/app',
        aliases => [{ alias => '/static', path => '/var/www/static' }],
      },
    },
  }

  class { 'web_stack::mysql':
    root_password => lookup('mysql::root_password', String, 'first', 'CHANGE_ME'),
    bind_address  => '127.0.0.1',
    databases     => {
      'appdb' => {
        user     => 'appuser',
        password => lookup('mysql::appdb_password', String, 'first', 'CHANGE_ME'),
        host     => 'localhost',
        grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
      },
    },
  }
}

# --- RHEL / CentOS web servers ---
node /^(web|app)-rhel/ {
  # SELinux: allow Apache to connect to network (needed for proxying)
  if $facts['os']['selinux']['enabled'] {
    selboolean { 'httpd_can_network_connect':
      value      => on,
      persistent => true,
    }
  }

  class { 'web_stack::apache':
    server_name => $facts['networking']['fqdn'],
    docroot     => '/var/www/html',
    vhosts      => {
      'app.example.com' => {
        port    => 80,
        docroot => '/var/www/app',
      },
    },
  }

  class { 'web_stack::mysql':
    root_password => lookup('mysql::root_password', String, 'first', 'CHANGE_ME'),
    bind_address  => '127.0.0.1',
    databases     => {
      'appdb' => {
        user     => 'appuser',
        password => lookup('mysql::appdb_password', String, 'first', 'CHANGE_ME'),
        host     => 'localhost',
        grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
      },
    },
  }
}

# --- Shared / generic nodes (both Ubuntu and RHEL) ---
node 'db.example.com' {
  # Database-only node — no Apache
  class { 'web_stack::mysql':
    root_password    => lookup('mysql::root_password', String, 'first', 'CHANGE_ME'),
    bind_address     => '0.0.0.0',   # allow remote connections
    max_connections  => 500,
    databases        => {
      'production_db' => {
        user     => 'prod_user',
        password => lookup('mysql::prod_password', String, 'first', 'CHANGE_ME'),
        host     => '%',            # allow from any host (restrict with firewall)
        grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'INDEX'],
      },
    },
  }
}
