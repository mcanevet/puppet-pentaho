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

  file {"/srv/tomcat/${name}/conf/Catalina/localhost/pentaho.xml":
    ensure  => $ensure,
    content => template('pentaho/pentaho_context.xml.erb'),
  }

}
