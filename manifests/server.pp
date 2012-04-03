class pentaho::server($database) {
	if($database == "postgresql8"){
	$driverClassName = "org.postgresql.Driver"
	$quartzURL = "jdbc:postgresql://localhost:5432/quartz"
	$hibernateURL = "jdbc:postgresql://localhost:5432/hibernate"
	$hibernateUsername = "hibuser"
	$hibernatePassword = "password"
	$hibernateDialect = "org.hibernate.dialect.PostgreSQLDialect"
	$configFile	= "system/hibernate/postgresql.hibernate.cfg.xml"
	}
	if ($database == "mysql"){
	$driverClassName = "com.mysql.jdbc.Driver"
	$quartzURL="jdbc:mysql://localhost/quartz"
	$hibernateURL="jdbc:mysql://localhost/hibernate"
	$hibernateUsername="hibuser"
	$hibernatePassword="password"
	$hibernateDialect="org.hibernate.dialect.MySQL5InnoDBDialect"
	$configFile	="system/hibernate/mysql5.hibernate.cfg.xml"
	}
	
	
	package {
		"pentaho-biserver" :
			ensure => present,
	}
	
	file {
		"/usr/bin/remove_config.sh":
		source => "puppet:///modules/pentaho/remove_config.sh",
		mode => 700,
		ensure => present,
	}
	
	exec { "remove dud configs":
    command => "/usr/bin/remove_config.sh",
    creates => "/opt/.pentahoinit",
    require => [File["/usr/bin/remove_config.sh"], Package["pentaho-biserver"]]
	}
	
	file {
		'/opt/pentaho-solutions/system/quartz/quartz.properties' :
			ensure => present,
			content => template('pentaho/quartz.properties.erb'),
			mode => 755,
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
			notify => Service["tomcat-pentaho_biserver"],
	}
	
	file {
		'/opt/administration-console/resource/config/console.xml' :
			ensure => present,
			content => template('pentaho/admin_console.xml.erb'),
			mode => 755,
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
			notify => Service["tomcat-pentaho_biserver"],
	}

	#pentaho/META-INF/context.xml
	file {
		'/srv/tomcat/pentaho_biserver/webapps/pentaho/META-INF/context.xml' :
			ensure => present,
			content => template('pentaho/pentaho_context.xml.erb'),
			mode => 755,
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			notify => Service["tomcat-pentaho_biserver"],
			replace => true,
	}
	file {
		["/srv/tomcat/pentaho_biserver/conf/",
		"/srv/tomcat/pentaho_biserver/conf/Catalina/",
		"/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/"] :
			ensure => "directory",
			mode => 755,
			require => Package["pentaho-biserver"],
			replace => true,
	}
	#pentaho/META-INF/context.xml
	file {
		'/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/pentaho.xml' :
			ensure => present,
			content => template('pentaho/pentaho_context.xml.erb'),
			mode => 755,
			require => [Package["pentaho-biserver"],Exec["remove dud configs"],
			File["/srv/tomcat/pentaho_biserver/conf/",
			"/srv/tomcat/pentaho_biserver/conf/Catalina/",
			"/srv/tomcat/pentaho_biserver/conf/Catalina/localhost/"]],
			notify => Service["tomcat-pentaho_biserver"],
			replace => true,
	}
	#pentaho/WEB-INF/web.xml
	file {
		'/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/web.xml' :
			ensure => present,
			content => template('pentaho/pentaho_web.xml.erb'),
			mode => 755,
			notify => Service["tomcat-pentaho_biserver"],
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
	}

	#pentaho-solutions/system/applicationContext-spring-security-hibernate.properties
	file {
		'/opt/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties' :
			ensure => present,
			content =>
			template('pentaho/solution_applicationContext-spring-security-hibernate.properties.erb'),
			mode => 755,
			notify => Service["tomcat-pentaho_biserver"],
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
	}

	#pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml
	file {
		'/opt/pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml' :
			ensure => present,
			content => template('pentaho/solution_mysql5.hibernate.cfg.xml.erb'),
			mode => 755,
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			notify => Service["tomcat-pentaho_biserver"],
			replace => true,
	}
	file {
		'/opt/pentaho-solutions/system/hibernate/hibernate-settings.xml' :
			ensure => present,
			content => template('pentaho/solution_hibernate-settings.xml.erb'),
			mode => 755,
			notify => Service["tomcat-pentaho_biserver"],
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
	}
	file {
		'/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/classes/log4j.xml' :
			ensure => present,
			content => template('pentaho/pentaho_log4j.xml.erb'),
			mode => 755,
			notify => Service["tomcat-pentaho_biserver"],
			require => [Package["pentaho-biserver"],Exec["remove dud configs"]],
			replace => true,
	}

	if($database == "mysql"){
	#mysql jar
	file {
		'/opt/apache-tomcat/lib/mysql-connector-java-5.1.17.jar' :
			ensure => present,
			notify => Service["tomcat-pentaho_biserver"],
			source => "puppet:///modules/pentaho/mysql-connector-java-5.1.17.jar",
			mode => 755,
	}

	#c3p0 jar
	file {
		'/opt/apache-tomcat/lib/c3p0-0.9.1.2.jar' :
			ensure => present,
			notify => Service["tomcat-pentaho_biserver"],
			source => "puppet:///modules/pentaho/c3p0-0.9.1.2.jar",
			mode => 755,
	}
	}
	
	if($database == "postgresql8"){
		file {
			'/opt/apache-tomcat/lib/postgresql-9.1-901.jdbc4.jar' :
				ensure => present,
				notify => Service["tomcat-pentaho_biserver"],
				source => "puppet:///modules/pentaho/postgresql-9.1-901.jdbc4.jar",
				mode => 755,
	}
		
	}
}