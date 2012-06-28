class pentaho::server {
  include pentaho::params
  include pentaho::apt

  $pentaho_user = $pentaho::params::pentaho_user
  $pentaho_password = $pentaho::params::pentaho_password
  $hibuser_password = $pentaho::params::hibuser_password

  $driverClassName = $pentaho::params::driverClassName
  $hibernateURL = $pentaho::params::hibernateURL
  $hibernateDialect = $pentaho::params::hibernateDialect
  $quartzURL = $pentaho::params::quartzURL
  $quartzDelegate = $pentaho::params::quartzDelegate
  $hibernateMappingResource = $pentaho::params::hibernateMappingResource
  $publisher_password = $pentaho::params::publisher_password


  package {'sun-java6-jre':
    ensure  => installed,
    require => Apt::Sources_list['oracle-java'],
  }

  # biserver           => package
  package {['pentaho-biserver-common', 'pentaho-biserver-wars']:
    ensure  => installed,
    require => Apt::Sources_list['pentaho'],
  }


  # X11 required for graphs => xvfb
  package {'xvfb':
    ensure => present,
  }

  # Java libs
  package {['libcommons-logging-java', 'liblog4j1.2-java', 'libpg-java', 'libc3p0-java', 'libpostgresql-jdbc-java']:
    ensure => present,
  }

  group {'pentaho':
    ensure => present,
  }

  # logdir and user provided by package pentaho-biserver-common
  file {'/var/log/pentaho':
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'pentaho',
    require => Package['pentaho-biserver-common'],
  }


  file {'/usr/share/tomcat6/lib/c3p0.jar':
    ensure => link,
    target => '/usr/share/java/c3p0.jar',
  }

  file {'/usr/share/pentaho/solutions/system/hibernate/postgresql.hibernate.cfg.xml':
    ensure  => $ensure,
    content => template('pentaho/solutions_db.hibernate.cfg.xml.erb'),
  }

  file {'/usr/share/pentaho/solutions/system/applicationContext-spring-security-hibernate.properties':
    ensure  => $ensure,
    content => template('pentaho/solutions_applicationContext-spring-security-hibernate.properties.erb'),
  }

  file {'/usr/share/pentaho/solutions/system/hibernate/hibernate-settings.xml':
    ensure => $ensure,
    source => 'file:///usr/share/pentaho/solutions/system/dialects/postgresql/hibernate/hibernate-settings.xml',
  }

  file {'/usr/share/pentaho/solutions/system/quartz/quartz.properties':
    ensure  => $ensure,
    content => template('pentaho/quartz.properties.erb'),
  }

  # Deactivate samples
  file {'/usr/share/pentaho/solutions/system/olap/datasources.xml':
    ensure  => present,
    content => '<?xml version="1.0" encoding="UTF-8"?>
<DataSources>
  <DataSource>
    <DataSourceName>Provider=Mondrian;DataSource=Pentaho</DataSourceName>
    <DataSourceDescription>Pentaho BI Platform Datasources</DataSourceDescription>
    <URL>http://localhost:8080/pentaho/Xmla?userid=joe&amp;password=password</URL>
    <DataSourceInfo>Provider=mondrian</DataSourceInfo>
    <ProviderName>PentahoXMLA</ProviderName>
    <ProviderType>MDP</ProviderType>
    <AuthenticationMode>Unauthenticated</AuthenticationMode>
    <Catalogs>
    </Catalogs>
  </DataSource>
</DataSources>
',
  }

  # Publish password
  file {'/usr/share/pentaho/solutions/system/publisher_config.xml':
    ensure  => present,
    content => template('pentaho/solutions_publisher_config.xml.erb'),
  }

}
