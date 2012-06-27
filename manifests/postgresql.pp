class pentaho::postgresql {
  include pentaho::params

# db settings
  $pentaho_user = $pentaho::params::pentaho_user
  $pentaho_password = $pentaho::params::pentaho_password
  $hibuser_password = $pentaho::params::hibuser_password

  $create_repository_sql    = '/usr/share/pentaho/data/postgresql/create_repository_postgresql.sql'
  $create_repository_sql_gz = '/opt/pentaho/data/create_repository_postgresql.sql.gz'
  $create_quartz_sql    = '/usr/share/pentaho/data/postgresql/create_quartz_postgresql.sql'
  $create_quartz_sql_gz = '/opt/pentaho/data/create_quartz_postgresql.sql.gz'

# db users

	postgresql::user {'hibuser':
			ensure     => present,
			password   => $hibuser_password,
			superuser  => false,
			createdb   => false,
			createrole => false,
	}

  postgresql::user {$pentaho_user:
      ensure     => present,
      password   => $pentaho_password,
      superuser  => false,
      createdb   => false,
      createrole => false,
  }

# db access
# /!\ Ordre dans pg_hba => full file?

  postgresql::hba {'access to database hibuser':
    ensure   => present,
    type     => 'local',
    database => 'hibernate',
    user     => 'all',
    method   => 'trust',
    pgver    => '9.0',
  }

  postgresql::hba {'access to sampledata database hibuser':
    ensure   => present,
    type     => 'local',
    database => 'sampledata',
    user     => 'all',
    method   => 'trust',
    pgver    => '9.0',
  }


  postgresql::hba {'access to quartz database pentaho_user':
    ensure   => present,
    type     => 'local',
    database => 'quartz',
    user     => 'all',
    method   => 'trust',
    pgver    => '9.0',
  }

# databases
  file {'/opt/pentaho':
    ensure => directory,
  }

  file {'/opt/pentaho/data':
    ensure  => directory,
    require => File['/opt/pentaho'],
  }

# TODO: Cleanup SQL scripts so they don't manage DB + users
  exec {"Create ${create_repository_sql_gz}":
    command => "/bin/sed -e 's@password@${hibuser_password}@' ${create_repository_sql} | /bin/gzip > ${create_repository_sql_gz}",
    creates => $create_repository_sql_gz,
    require => [File['/opt/pentaho/data'], Package['pentaho-biserver-common']],
  }

  exec {"Create ${create_quartz_sql_gz}":
    command => "/bin/sed -e 's@pentaho_user@${pentaho_user}@g;s@password@${pentaho_password}@' ${create_quartz_sql} | /bin/gzip > ${create_quartz_sql_gz}",
    creates => $create_quartz_sql_gz,
    require => [File['/opt/pentaho/data'], Package['pentaho-biserver-common']],
  }

  postgresql::database {'hibernate':
    ensure    => present,
    owner     => hibuser,
    encoding  => 'UTF8',
    template  => 'template1',
    source    => $create_repository_sql_gz,
    overwrite => false,
    require   => Postgresql::User['hibuser'],
  }

  postgresql::database {'quartz':
      ensure    => present,
      owner     => $pentaho_user,
      encoding  => 'UTF8',
      template  => 'template1',
      source    => $create_quartz_sql_gz,
      overwrite => false,
      require   => Postgresql::User[$pentaho_user],
  }

  # Jars.
  # TODO: package postgresql jdbc 4
  file {'/usr/share/tomcat6/lib/postgresql.jar':
    ensure => link,
    target => '/usr/local/share/java/postgresql-9.0-802.jdbc4.jar',
  }
}
