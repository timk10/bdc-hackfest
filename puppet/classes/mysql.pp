class mysql {
	package { "mysql-server":
		ensure => present,
		require => [Class["linux"]],
	}

	package { "mysql-client":
		ensure => present,
		require => [Class["linux"]],
	}
}

