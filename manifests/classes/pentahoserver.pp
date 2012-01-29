class pentaho::server {

 package { "pentaho-biserver":
     ensure => present,
    
     }
     
      file { '/opt/administration-console/resource/config/console.xml':
      ensure  => present,
      content => template('pentaho/admin_console.xml.erb'),
      mode    => 755,
      require => Package["pentaho-biserver"],
      replace => true,	
      notify => Service["tomcat-pentaho_biserver"],
      }
      
  #pentaho/META-INF/context.xml
    file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/META-INF/context.xml':
      ensure  => present,
      content => template('pentaho/pentaho_context.xml.erb'),
      mode    => 755,
      require => Package["pentaho-biserver"],
      notify => Service["tomcat-pentaho_biserver"],
      replace => true,
      }
    
      file { ["/srv/tomcat/pentaho_biserver/conf/",
        "/srv/tomcat/pentaho_biserver/conf/Catalina/",
        "/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/"]:
            ensure  => "directory",
            mode    => 755,
            require => Package["pentaho-biserver"],
            replace => true,
            }
    #pentaho/META-INF/context.xml
      file { '/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/pentaho.xml':
        ensure  => present,
        content => template('pentaho/pentaho_context.xml.erb'),
        mode    => 755,
        require => [Package["pentaho-biserver"], File["/srv/tomcat/pentaho_biserver/conf/",
        "/srv/tomcat/pentaho_biserver/conf/Catalina/",
        "/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/"]],
        notify => Service["tomcat-pentaho_biserver"],
        replace => true,
        }
#pentaho/WEB-INF/web.xml
    file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/web.xml':
    ensure  => present,
    content => template('pentaho/pentaho_web.xml.erb'),
    mode    => 755,
      notify => Service["tomcat-pentaho_biserver"],
    require => Package["pentaho-biserver"],
    replace => true,
    }

#pentaho-solutions/system/applicationContext-spring-security-hibernate.properties
    file { '/opt/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties':
    ensure  => present,
    content => template('pentaho/solution_applicationContext-spring-security-hibernate.properties.erb'),
    mode    => 755,
          notify => Service["tomcat-pentaho_biserver"],
    require => Package["pentaho-biserver"],
    replace => true,
    }

#pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml
    file { '/opt/pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml':
    ensure  => present,
    content => template('pentaho/solution_mysql5.hibernate.cfg.xml.erb'),
    mode    => 755,
    require => Package["pentaho-biserver"],
          notify => Service["tomcat-pentaho_biserver"],
    replace => true,
    }


      file { '/opt/pentaho-solutions/system/hibernate/hibernate-settings.xml':
      ensure  => present,
      content => template('pentaho/solution_hibernate-settings.xml.erb'),
      mode    => 755,
            notify => Service["tomcat-pentaho_biserver"],
        require => Package["pentaho-biserver"],
      replace => true,
      }
      
  file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/classes/log4j.xml':
    ensure  => present,
    content => template('pentaho/pentaho_log4j.xml.erb'),
    mode    => 755,
      notify => Service["tomcat-pentaho_biserver"],
    require => Package["pentaho-biserver"],
    replace => true,
    }
    
       #mysql jar
      file { '/opt/apache-tomcat/lib/mysql-connector-java-5.1.17.jar':
      ensure  => present,
            notify => Service["tomcat-pentaho_biserver"],
	  source => "puppet:///modules/pentaho/mysql-connector-java-5.1.17.jar",
      mode    => 755,
      }
      
      #c3p0 jar
      file { '/opt/apache-tomcat/lib/c3p0-0.9.1.2.jar':
      ensure  => present,
            notify => Service["tomcat-pentaho_biserver"],
	  source => "puppet:///modules/pentaho/c3p0-0.9.1.2.jar",
      mode    => 755,
      }
 
}