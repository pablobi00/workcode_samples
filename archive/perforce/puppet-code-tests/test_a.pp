# Puppet manifest for demo environment with Apache, MySQL, and LDAP
# Node definition for demo server

node 'demo-server' {
  # Apache web server
  class { 'apache':
    default_vhost => true,
  }

  apache::vhost { 'demo.local':
    port    => 80,
    docroot => '/var/www/demo',
  }

  # MySQL database server
  class { 'mysql::server':
    root_password           => 'demo_password',
    remove_default_accounts => true,
  }

  mysql::db { 'demo_db':
    user     => 'demo_user',
    password => 'demo_db_pass',
    host     => 'localhost',
    grant    => ['ALL'],
  }

  # LDAP server (OpenLDAP)
  class { 'openldap::server':
    suffix => 'dc=demo,dc=local',
    rootdn => 'cn=admin,dc=demo,dc=local',
    rootpw => 'demo_ldap_pass',
  }

  # LDAP client configuration
  class { 'sssd':
    enable_ldap => true,
  }
}
