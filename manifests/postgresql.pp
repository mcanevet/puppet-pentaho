class pentaho::postgresql {
#	mysql::database {
#		"hibernate" :
#			ensure => present
#	}
#	mysql::rights {
#		"hibernate rights" :
#			ensure => present,
#			database => "hibernate",
#			user => "hibuser",
#			password => "password",
#			require => Mysql::Database["hibernate"],
#	}
#	file {
#		"/srv/pentahodata/create_repository_mysql.sql" :
#			mode => 440,
#			owner => root,
#			group => root,
#			source => "puppet:///modules/pentaho/create_repository_mysql.sql",
#			require => Mysql::Rights["hibernate rights"],
#			notify => Exec["importhibernate"],
#	}
#	exec {
#		"importhibernate" :
#			cwd => "/tmp",
#			command =>
#			"mysql -uroot hibernate < /srv/pentahodata/create_repository_mysql.sql",
#			refreshonly => true,
#			require => File["/srv/pentahodata/create_repository_mysql.sql"],
#	}
#	file {
#		"/srv/pentahodata/create_sample_datasource_mysql.sql" :
#			mode => 440,
#			owner => root,
#			group => root,
#			source => "puppet:///modules/pentaho/create_sample_datasource_mysql.sql",
#			require => Mysql::Rights["hibernate rights"],
#			notify => Exec["importhibernate2"],
#	}
#	exec {
#		"importhibernate2" :
#			cwd => "/tmp",
#			command =>
#			"mysql -uroot hibernate < /srv/pentahodata/create_sample_datasource_mysql.sql",
#			refreshonly => true,
#			require => [File["/srv/pentahodata/create_sample_datasource_mysql.sql"], Exec["importhibernate"]],
#	}
#	mysql::database {
#		"sampledata" :
#			ensure => present
#	}
#	mysql::rights {
#		"sampledata rights" :
#			ensure => present,
#			database => "sampledata",
#			user => "pentaho_user",
#			password => "password",
#			require => Mysql::Database["sampledata"],
#	}
#	file {
#		"/srv/pentahodata/sampledata_mysql.sql" :
#			mode => 440,
#			owner => root,
#			group => root,
#			source => "puppet:///modules/pentaho/sampledata_mysql.sql",
#			require => Mysql::Rights["sampledata rights"],
#			notify => Exec["importsampledata"],
#	}

  file { "/srv/pentahodata/sampledata_postgresql.sql.gz":
    mode => 440,
    owner => root,
    group => root,
    source => "puppet:///modules/pentaho/sample_data_postgresql.sql.gz",
    require => File["/srv/pentahodata"],
    notify => Postgresql::Database["sampledata"],
  }
postgresql::database{ "sampledata":
  ensure=>present,
  owner=>postgres,
  encoding=>"UTF8",
  template=>"template1",
  source=>"/srv/pentahodata/sampledata_postgresql.sql.gz",
  overwrite=>false
  }
   
#	exec {
#		"importsampledata" :
#			cwd => "/tmp",
#			command =>
#			"mysql -uroot sampledata < /srv/pentahodata/sampledata_mysql.sql",
#			refreshonly => true,
#			require => File["/srv/pentahodata/sampledata_mysql.sql"],
#	}
#	mysql::database {
#		"quartz" :
#			ensure => present
#	}
#	mysql::rights {
#		"quartz rights" :
#			ensure => present,
#			database => "quartz",
#			user => "pentaho_user",
#			password => "password",
#			require => Mysql::Database["quartz"],
#	}
#	file {
#		"/srv/pentahodata/create_quartz_mysql.sql" :
#			mode => 440,
#			owner => root,
#			group => root,
#			source => "puppet:///modules/pentaho/create_quartz_mysql.sql",
#			require => Mysql::Rights["quartz rights"],
#			notify => Exec["importquartz"],
#	}
#	exec {
#		"importquartz" :
#			cwd => "/tmp",
#			command => "mysql -uroot quartz < /srv/pentahodata/create_quartz_mysql.sql",
#			refreshonly => true,
#			require => File["/srv/pentahodata/create_quartz_mysql.sql"],
#	}
}
