class pentaho::postgresql {
	file {
		"/srv/pentahodata/create_repository_postgresql.sql.gz" :
			mode => 750,
			owner => postgres,
			group => postgres,
			source => "puppet:///modules/pentaho/create_repository_postgresql.sql.gz",
			require => File["/srv/pentahodata"],
			notify => Postgresql::Database["hibernate"],
	}
	postgresql::database {
		"hibernate" :
			ensure => present,
			owner => hibuser,
			encoding => "UTF8",
			template => "template1",
			source => "/srv/pentahodata/create_repository_postgresql.sql.gz",
			overwrite => false,
			require => Postgresql::User["hibuser"],
	}
	postgresql::user {
		"hibuser" :
			ensure => present,
			password => "password",
			superuser => false,
			createdb => false,
			createrole => false,
	}
	postgresql::hba {
		"access to database hibuser" :
			ensure => present,
			type => 'local',
			database => 'hibernate',
			user => 'all',
			method => 'trust',
			pgver => '8.4',
	}
		postgresql::hba {
		"access to quartz database pentaho_user" :
			ensure => present,
			type => 'local',
			database => 'quartz',
			user => 'all',
			method => 'trust',
			pgver => '8.4',
	}
		postgresql::hba {
		"access to sampledata database hibuser" :
			ensure => present,
			type => 'local',
			database => 'sampledata',
			user => 'all',
			method => 'trust',
			pgver => '8.4',
	}
	file {
		"/srv/pentahodata/create_quartz_postgresql.sql.gz" :
			mode => 750,
			owner => postgres,
			group => postgres,
			source => "puppet:///modules/pentaho/create_quartz_postgresql.sql.gz",
			require => File["/srv/pentahodata"],
			notify => Postgresql::Database["quartz"],
	}
	postgresql::database {
		"quartz" :
			ensure => present,
			owner => pentaho_user,
			encoding => "UTF8",
			template => "template1",
			source => "/srv/pentahodata/sampledata_postgresql.sql.gz",
			overwrite => false,
			require => Postgresql::User["pentaho_user"],
	}
	postgresql::user {
		"pentaho_user" :
			ensure => present,
			password => "password",
			superuser => false,
			createdb => false,
			createrole => false,
	}
	file {
		"/srv/pentahodata/create_sample_datasource_postgresql.sql.gz" :
			mode => 750,
			owner => postgres,
			group => postgres,
			source =>
			"puppet:///modules/pentaho/create_sample_datasource_postgresql.sql.gz",
			require => File["/srv/pentahodata"],
	}
	exec {
		"Import dump into create datasource postgres db" :
			command =>
			"zcat /srv/pentahodata/create_sample_datasource_postgresql.sql.gz | psql hibernate",
			user => "postgres",
			require => [Postgresql::Database["hibernate"],
			File["/srv/pentahodata/create_sample_datasource_postgresql.sql.gz"]],
	}
	file {
		"/srv/pentahodata/load_sample_users_postgresql.sql.gz" :
			mode => 750,
			owner => postgres,
			group => postgres,
			source => "puppet:///modules/pentaho/load_sample_users_postgresql.sql.gz",
			require => File["/srv/pentahodata"],
	}
	exec {
		"Import dump into load sample users postgres db" :
			command =>
			"zcat /srv/pentahodata/load_sample_users_postgresql.sql.gz | psql hibernate",
			user => "postgres",
			require => [Postgresql::Database["hibernate"],
			File["/srv/pentahodata/load_sample_users_postgresql.sql.gz"]],
	}
	file {
		"/srv/pentahodata/sampledata_postgresql.sql.gz" :
			mode => 750,
			owner => postgres,
			group => postgres,
			source => "puppet:///modules/pentaho/sample_data_postgresql.sql.gz",
			require => File["/srv/pentahodata"],
			notify => Postgresql::Database["sampledata"],
	}
	postgresql::database {
		"sampledata" :
			ensure => present,
			owner => postgres,
			encoding => "UTF8",
			template => "template1",
			source => "/srv/pentahodata/sampledata_postgresql.sql.gz",
			overwrite => false
	}
}
