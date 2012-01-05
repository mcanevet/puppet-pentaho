class pentaho::server {
 
 # 
      #pentaho/META-INF/context.xml
      file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/META-INF/context.xml':
        ensure  => present,
        content => template('pentaho/pentaho_context.xml.erb'),
        mode    => 755,
        }

  #pentaho/WEB-INF/web.xml
      file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/web.xml':
      ensure  => present,
      content => template('pentaho/pentaho_web.xml.erb'),
      mode    => 755,
      }

  #pentaho-solutions/system/applicationContext-spring-security-hibernate.properties
      file { '/opt/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties':
      ensure  => present,
      content => template('pentaho/solution_applicationContext-spring-security-hibernate.properties.erb'),
      mode    => 755,
      }

  #pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml
      file { '/opt/pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml':
      ensure  => present,
      content => template('pentaho/solution_mysql5.hibernate.cfg.xml.erb'),
      mode    => 755,
      }
 
   #mysql jar
      file { '/opt/apache-tomcat/lib/mysql-connector-java-5.1.17.jar':
      ensure  => present,
	  source => "puppet:///modules/pentaho/mysql-connector-java-5.1.17.jar",
      mode    => 755,
      }
      
      #c3p0 jar
      file { '/opt/apache-tomcat/lib/c3p0-0.9.1.2.jar':
      ensure  => present,
	  source => "puppet:///modules/pentaho/c3p0-0.9.1.2.jar",
      mode    => 755,
      }
 
}