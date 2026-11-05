# Puppet manifest to manage IIS on Windows Server
# Requires: puppetlabs/iis module
# Node definition for IIS web server

node 'iis-server' {

  # ── 1. Install IIS Windows Feature ──────────────────────────────────────────

  # Core IIS web server role and common sub-features
  $iis_features = [
    'Web-Server',            # IIS core role
    'Web-WebServer',         # Web server sub-role container
    'Web-Common-Http',       # Default/static content, HTTP errors, redirection
    'Web-Default-Doc',       # Default document support
    'Web-Dir-Browsing',      # Directory browsing
    'Web-Http-Errors',       # HTTP error pages
    'Web-Static-Content',    # Static file serving
    'Web-Http-Redirect',     # HTTP redirection
    'Web-Health',            # Health and diagnostics container
    'Web-Http-Logging',      # HTTP request logging
    'Web-Request-Monitor',   # Active request monitoring
    'Web-Performance',       # Performance features container
    'Web-Stat-Compression',  # Static content compression
    'Web-Dyn-Compression',   # Dynamic content compression
    'Web-Security',          # Security features container
    'Web-Filtering',         # Request filtering
    'Web-Basic-Auth',        # Basic authentication
    'Web-Windows-Auth',      # Windows authentication
    'Web-App-Dev',           # Application development container
    'Web-Net-Ext45',         # .NET extensibility 4.x
    'Web-Asp-Net45',         # ASP.NET 4.x
    'Web-ISAPI-Ext',         # ISAPI extensions
    'Web-ISAPI-Filter',      # ISAPI filters
    'Web-Mgmt-Tools',        # Management tools container
    'Web-Mgmt-Console',      # IIS Management Console
  ]

  $iis_features.each |String $feature| {
    windowsfeature { $feature:
      ensure => present,
    }
  }

  # ── 2. Ensure IIS service is running ────────────────────────────────────────

  service { 'W3SVC':
    ensure  => running,
    enable  => true,
    require => Windowsfeature['Web-Server'],
  }

  # ── 3. Manage Application Pools ─────────────────────────────────────────────

  iis_application_pool { 'DefaultAppPool':
    ensure                => present,
    state                 => started,
    managed_runtime_version => 'v4.0',
    managed_pipeline_mode => 'Integrated',
    start_mode            => 'OnDemand',
    idle_timeout          => '00:20:00',
    max_processes         => 1,
    require               => Service['W3SVC'],
  }

  iis_application_pool { 'DemoAppPool':
    ensure                  => present,
    state                   => started,
    managed_runtime_version => 'v4.0',
    managed_pipeline_mode   => 'Integrated',
    start_mode              => 'AlwaysRunning',
    idle_timeout            => '00:00:00',
    max_processes           => 0,   # 0 = use all available CPUs (Web Garden)
    require                 => Service['W3SVC'],
  }

  # ── 4. Manage Websites ──────────────────────────────────────────────────────

  # Default Website — disabled in favour of dedicated virtual hosts
  iis_site { 'Default Web Site':
    ensure  => present,
    state   => stopped,
    require => Service['W3SVC'],
  }

  # Primary demo virtual host
  iis_site { 'demo.local':
    ensure           => present,
    state            => started,
    physical_path    => 'C:\\inetpub\\wwwroot\\demo',
    application_pool => 'DemoAppPool',
    bindings         => [
      {
        protocol  => 'http',
        port      => 80,
        host_name => 'demo.local',
        ip        => '*',
      },
      {
        protocol              => 'https',
        port                  => 443,
        host_name             => 'demo.local',
        ip                    => '*',
        ssl_flag              => 1,
        certificate_hash      => '',   # set thumbprint here when cert is available
        certificate_store_name => 'My',
      },
    ],
    require          => [
      Iis_application_pool['DemoAppPool'],
      File['C:\\inetpub\\wwwroot\\demo'],
    ],
  }

  # ── 5. Web Root Directory ───────────────────────────────────────────────────

  file { 'C:\\inetpub\\wwwroot\\demo':
    ensure => directory,
    owner  => 'IIS_IUSRS',
  }

  # Placeholder index page
  file { 'C:\\inetpub\\wwwroot\\demo\\index.html':
    ensure  => file,
    content => "<html><body><h1>IIS managed by Puppet</h1></body></html>\r\n",
    owner   => 'IIS_IUSRS',
    require => File['C:\\inetpub\\wwwroot\\demo'],
  }

  # ── 6. IIS Logging ──────────────────────────────────────────────────────────

  # Centralise log storage (optional — adjust path to match your policy)
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\LogFileDirectory':
    ensure => present,
    type   => string,
    data   => 'D:\\Logs\\IIS',
  }

  # ── 7. Request Filtering ─────────────────────────────────────────────────────

  # Block common attack vectors at the IIS layer
  iis_application { 'demo.local/':
    ensure           => present,
    application_pool => 'DemoAppPool',
    physical_path    => 'C:\\inetpub\\wwwroot\\demo',
    require          => Iis_site['demo.local'],
  }

  # ── 8. Windows Firewall ──────────────────────────────────────────────────────

  windows_firewall_rule { 'Allow HTTP':
    ensure    => present,
    direction => 'in',
    action    => 'allow',
    protocol  => 'TCP',
    local_port => '80',
  }

  windows_firewall_rule { 'Allow HTTPS':
    ensure     => present,
    direction  => 'in',
    action     => 'allow',
    protocol   => 'TCP',
    local_port => '443',
  }
}
