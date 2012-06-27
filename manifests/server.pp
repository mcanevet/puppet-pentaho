class pentaho::server {
  include pentaho::params
  include pentaho::apt

  $pentaho_user = $pentaho::params::pentaho_user
  $pentaho_password = $pentaho::params::pentaho_password
  $hibuser_password = $pentaho::params::hibuser_password

  package {'sun-java6-jre':
    ensure  => installed,
    require => Apt::Sources_list['oracle-java'],
  }

  # biserver           => package
  package {['pentaho-biserver-common', 'pentaho-biserver-wars', 'pentaho-biserver-plugin-saiku']:
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

  # TODO: Use Augeas XML lens with puppet 2.X
  file {'/usr/share/pentaho/solutions/system/hibernate/postgresql.hibernate.cfg.xml':
    ensure => $ensure,
    content => "<?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE hibernate-configuration
    PUBLIC \"-//Hibernate/Hibernate Configuration DTD//EN\"
    \"http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd\">
    <hibernate-configuration>
    <session-factory>

    <!-- C3P0 connection pool -->
    <property name=\"connection.provider_class\">org.hibernate.connection.C3P0ConnectionProvider</property>
    <property name=\"hibernate.c3p0.acquire_increment\">3</property>
    <property name=\"hibernate.c3p0.idle_test_period\">10</property>
    <property name=\"hibernate.c3p0.min_size\">5</property>
    <property name=\"hibernate.c3p0.max_size\">75</property>
    <property name=\"hibernate.c3p0.max_statements\">0</property>
    <property name=\"hibernate.c3p0.timeout\">25200</property>
    <property name=\"hibernate.c3p0.preferredTestQuery\">select 1</property>
    <property name=\"hibernate.c3p0.testConnectionOnCheckout\">true</property>
    <!-- /C3P0 connection pool -->

    <property name=\"cache.provider_class\">org.hibernate.cache.EhCacheProvider</property>

    <property name=\"hibernate.generate_statistics\">true</property>
    <property name=\"hibernate.cache.use_query_cache\">true</property>
    <!--  Postgres 8 Configuration -->
    <property name=\"connection.driver_class\">org.postgresql.Driver</property>
    <property name=\"connection.url\">jdbc:postgresql://localhost:5432/hibernate</property>
    <property name=\"dialect\">org.hibernate.dialect.PostgreSQLDialect</property>
    <property name=\"connection.username\">hibuser</property>
    <property name=\"connection.password\">${hibuser_password}</property>
    <property name=\"connection.pool_size\">10</property>
    <property name=\"show_sql\">false</property>
    <property name=\"hibernate.jdbc.use_streams_for_binary\">true</property>
    <!-- replaces DefinitionVersionManager -->
    <property name=\"hibernate.hbm2ddl.auto\">update</property>
    <!-- load resource from classpath -->
    <mapping resource=\"hibernate/postgresql.hbm.xml\" />
    <!--  This is only used by Pentaho Administration Console. Spring Security will not use these mapping files --> 
    <mapping resource=\"PentahoUser.hbm.xml\" />
    <mapping resource=\"PentahoRole.hbm.xml\" />
    <mapping resource=\"PentahoUserRoleMapping.hbm.xml\" />

    </session-factory>
    </hibernate-configuration>
    "
  }

  # TODO: Use Augeas properties lens with puppet 2.X
  file {'/usr/share/pentaho/solutions/system/applicationContext-spring-security-hibernate.properties':
    ensure  => $ensure,
    content => "jdbc.driver=org.postgresql.Driver
    jdbc.url=jdbc:postgresql://localhost:5432/hibernate
    jdbc.username=hibuser
    jdbc.password=${hibuser_password}
    hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
    ",
  }

  file {'/usr/share/pentaho/solutions/system/hibernate/hibernate-settings.xml':
    ensure => $ensure,
    source => 'file:///usr/share/pentaho/solutions/system/dialects/postgresql/hibernate/hibernate-settings.xml',
  }

  # TODO: Use Augeas properties lens with puppet 2.X
  file {'/usr/share/pentaho/solutions/system/quartz/quartz.properties':
    ensure  => $ensure,
    content => 'org.quartz.scheduler.instanceName = PentahoQuartzScheduler
    org.quartz.scheduler.instanceId = 1
    org.quartz.scheduler.rmi.export = false
    org.quartz.scheduler.rmi.proxy = false
    org.quartz.scheduler.wrapJobExecutionInUserTransaction = false
    org.quartz.threadPool.class = org.quartz.simpl.SimpleThreadPool
    org.quartz.threadPool.threadCount = 10
    org.quartz.threadPool.threadPriority = 5
    org.quartz.threadPool.threadsInheritContextClassLoaderOfInitializingThread = true

    org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX

    org.quartz.jobStore.misfireThreshold = 60000
    # Set this with Augeas in the future
    org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.PostgreSQLDelegate
    org.quartz.jobStore.useProperties = false
    org.quartz.jobStore.dataSource = myDS
    org.quartz.jobStore.tablePrefix = QRTZ_
    org.quartz.jobStore.isClustered = false

    org.quartz.dataSource.myDS.jndiURL = Quartz
    ',
  }

}
