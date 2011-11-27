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
define pentaho::biserver::instance($ensure , $tomcat_http, $tomcat_ajp, $tomcat_server) {

  include tomcat::source

  package { "pentaho-biserver":
     ensure => present,
     require => Tomcat::Instance["pentaho_biserver"],
     }
     
  tomcat::instance {"pentaho_biserver":
    ensure      => present,
    ajp_port    => "${tomcat_ajp}",
    server_port    => "${tomcat_server}",
    http_port    => "${tomcat_http}",
  }
  
  class { "pentaho::mysql":
    require => Package["pentaho-biserver"],
  }
  #pentaho/META-INF/context.xml
    file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/META-INF/context.xml':
      ensure  => present,
      content => template('pentaho/pentaho_context.xml.erb'),
      mode    => 755,
      require => Package["pentaho-biserver"],
      }

#pentaho/WEB-INF/web.xml
    file { '/srv/tomcat/pentaho_biserver/webapps/pentaho/WEB-INF/web.xml':
    ensure  => present,
    content => template('pentaho/pentaho_web.xml.erb'),
    mode    => 755,
      require => Package["pentaho-biserver"],
    }

#pentaho-solutions/system/applicationContext-spring-security-hibernate.properties
    file { '/opt/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties':
    ensure  => present,
    content => template('pentaho/solution_applicationContext-spring-security-hibernate.properties.erb'),
    mode    => 755,
      require => Package["pentaho-biserver"],
    }

#pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml
    file { '/opt/pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml':
    ensure  => present,
    content => template('pentaho/solution_mysql5.hibernate.cfg.xml.erb'),
    mode    => 755,
      require => Package["pentaho-biserver"],
    }


}