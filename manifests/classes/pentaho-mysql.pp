class pentaho::mysql {

  include mysql::server

  mysql::database{"hibernate":
    ensure   => present
  }


  mysql::rights{"hibernate rights":
    ensure   => present,
    database => "hibernate",
    user     => "hibuser",
    password => "password",
    require => Mysql::Database["hibernate"],
  }

  file { "/tmp/create_repository_mysql.sql":
    mode => 440,
    owner => root,
    group => root,
    source => "puppet:///modules/pentaho/create_repository_mysql.sql",
    require => Mysql::Rights["hibernate rights"],
    notify => Exec["importhibernate"],
  }

  exec { "importhibernate":
    cwd => "/tmp",
    command => "mysql -uroot hibernate < /tmp/create_repository_mysql.sql",
    refreshonly => true,
    require => File["/tmp/create_repository_mysql.sql"],
  }


  file { "/tmp/create_sample_datasource_mysql.sql":
    mode => 440,
    owner => root,
    group => root,
    source => "puppet:///modules/pentaho/create_sample_datasource_mysql.sql",
    require => Mysql::Rights["hibernate rights"],
    notify => Exec["importhibernate2"],
  }

  exec { "importhibernate2":
    cwd => "/tmp",
    command => "mysql -uroot hibernate < /tmp/create_sample_datasource_mysql.sql",
    refreshonly => true,
    require => File["/tmp/create_sample_datasource_mysql.sql"],
  }


  mysql::database{"sampledata":
    ensure   => present
  }


  mysql::rights{"sampledata rights":
    ensure   => present,
    database => "sampledata",
    user     => "pentaho_user",
    password => "password",
    require => Mysql::Database["sampledata"],
  }

  file { "/tmp/sampledata_mysql.sql":
    mode => 440,
    owner => root,
    group => root,
    source => "puppet:///modules/pentaho/sampledata_mysql.sql",
    require => Mysql::Rights["sampledata rights"],
    notify => Exec["importsampledata"],
  }

  exec { "importsampledata":
    cwd => "/tmp",
    command => "mysql -uroot sampledata < /tmp/sampledata_mysql.sql",
    refreshonly => true,
    require => File["/tmp/sampledata_mysql.sql"],
  }


  mysql::database{"quartz":
    ensure   => present
  }


  mysql::rights{"quartz rights":
    ensure   => present,
    database => "quartz",
    user     => "pentaho_user",
    password => "password",
    require => Mysql::Database["quartz"],
  }

  file { "/tmp/create_quartz_mysql.sql":
    mode => 440,
    owner => root,
    group => root,
    source => "puppet:///modules/pentaho/create_quartz_mysql.sql",
    require => Mysql::Rights["quartz rights"],
    notify => Exec["importquartz"],
  }

  exec { "importquartz":
    cwd => "/tmp",
    command => "mysql -uroot quartz < /tmp/create_quartz_mysql.sql",
    refreshonly => true,
    require => File["/tmp/create_quartz_mysql.sql"],
  }




}
