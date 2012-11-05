class pentaho::params {

  $pentaho_password = $pentaho_pentaho_password
  $hibuser_password = $pentaho_hibuser_password
  $publisher_password = $pentaho_publisher_password

  $pentaho_user = 'pentaho'

  $driverClassName = 'org.postgresql.Driver'
  $hibernateURL = 'jdbc:postgresql://localhost:5432/hibernate'
  $hibernateDialect = 'org.hibernate.dialect.PostgreSQLDialect'
  $quartzURL = 'jdbc:postgresql://localhost:5432/quartz'
  $quartzDelegate = 'org.quartz.impl.jdbcjobstore.PostgreSQLDelegate'
  $hibernateMappingResource = 'hibernate/postgresql.hbm.xml'
}
