define pentaho::plugin ($ensure='present') {
  package {"pentaho-biserver-plugin-${name}":
    ensure => $ensure,
  }
}
