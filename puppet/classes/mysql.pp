$mysqluser = "$puppetdir/mysqluser.version"
class mysql {
	package { "mysql-server":
		ensure => present,
		require => [Class["linux"]],
	}

	package { "mysql-client":
		ensure => present,
		require => [Class["linux"]],
	}
	
    exec { "mysqladduser":
		path => "$execpath",
    	command => "/vagrant/createdb.sh testdb testuser password",
		require => [Package["mysql-server"], Package["mysql-client"]],
        creates => "$mysqluser",
        user => root,
	}
}

