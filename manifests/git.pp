class pentaho::git {
	include git 
	group {
		"pentaho" :
			ensure => "present",
			system => true,
	}
	user {
		"git" :
			ensure => present,
			comment => "Git User",
			shell => "/bin/bash",
			home => "/srv/git",
			system => true,
			require => Group[pentaho],
	}
	User <| title == tomcat |> {
		groups +> ["pentaho"]
	}
}
