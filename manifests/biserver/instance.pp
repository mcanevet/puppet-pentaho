#
# pentahoinstance.pp
# 
# Copyright (c) 2011, OSBI Ltd. All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301  USA
#
define pentaho::biserver::instance ($ensure) {

  include pentaho::params
  include pentaho::server
  include tomcat

  $pentaho_user = $pentaho::params::pentaho_user
  $pentaho_password = $pentaho::params::pentaho_password
  $hibuser_password = $pentaho::params::hibuser_password

  tomcat::instance {$name:
    ensure  => $ensure,
    owner   => 'pentaho',
    group   => 'pentaho',
    require => Package['pentaho-biserver-common'],
    setenv  => ['PENTAHO_INSTALLED_LICENSE_PATH="/home/pentaho/.installedLicenses.xml"'],
  }

  file {"/srv/tomcat/${name}/webapps/pentaho.war":
    ensure  => $ensure,
    source  => 'file:///usr/share/pentaho/wars/tomcat/pentaho.war',
    owner   => 'pentaho',
    group   => 'pentaho',
    require => Package['pentaho-biserver-wars'],
  }


  file {"/srv/tomcat/${name}/webapps/pentaho-style.war":
    ensure => $ensure,
    source => 'file:///usr/share/pentaho/wars/pentaho-style.war',
    owner  => 'pentaho',
    group  => 'pentaho',
    require => Package['pentaho-biserver-wars'],
  }

  include pentaho::postgresql

  # Config files

  # TODO: Use Augeas XML lens with puppet 2.X
  file {"/srv/tomcat/${name}/conf/Catalina/localhost/pentaho.xml":
    ensure  => $ensure,
    content => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Context path=\"/pentaho\" docbase=\"webapps/pentaho/\">
    <Resource name=\"jdbc/Hibernate\" auth=\"Container\" type=\"javax.sql.DataSource\"
    factory=\"org.apache.commons.dbcp.BasicDataSourceFactory\" maxActive=\"20\" maxIdle=\"5\"
    maxWait=\"10000\" username=\"hibuser\" password=\"${hibuser_password}\"
    driverClassName=\"org.postgresql.Driver\" url=\"jdbc:postgresql://localhost:5432/hibernate\"
    validationQuery=\"select 1\" />

    <Resource name=\"jdbc/Quartz\" auth=\"Container\" type=\"javax.sql.DataSource\"
    factory=\"org.apache.commons.dbcp.BasicDataSourceFactory\" maxActive=\"20\" maxIdle=\"5\"
    maxWait=\"10000\" username=\"${pentaho_user}\" password=\"${pentaho_password}\"
    driverClassName=\"org.postgresql.Driver\" url=\"jdbc:postgresql://localhost:5432/quartz\"
    validationQuery=\"select 1\"/>
    </Context>",
  }

}
