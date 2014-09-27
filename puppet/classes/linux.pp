# Define global version dir
$puppetdir = "/var/log/puppet"
$installdir = "/opt/puppet/opt"
$envpath = "/etc/environment"
$execpath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
$rootpath = "/var/www"
$aptversionfile = "$puppetdir/apt.version"

class linux {

		# Create version dir
		file { "$puppetdir":
			owner => root,
			group => root,
			ensure => directory,
		}
	
		# Create install dir	
		file { [ "/opt/puppet", "$installdir" ]:
			owner => root,
			group => root,
			ensure => directory,
		}

		# Create web dir
		file { "/var/www":
			owner => root,
			group => root,
			ensure => directory,
		}

		# Run apt-get update when anything beneath /etc/apt/ changes
		exec { "apt-get update":
    			command => "/usr/bin/apt-get update && touch $aptversionfile",
		}

		exec { "env-rootpath":
			path => "$execpath",
			user => root,
			command => "echo ROOTPATH=$rootpath >> $envpath",
			onlyif => "[ \"`/bin/grep ROOTPATH $envpath`\" = \"\" ]",
			require => File["$puppetdir"],
		}

		package { "vim":
			ensure => present,
			require => Exec["apt-get update"],
		}

		package { "curl":
			ensure => present,
			require => Exec["apt-get update"],
		}

		package { "make":
			ensure => present,
			require => Exec["apt-get update"],
		}

		package { "git":
			ensure => present,
			require => Exec["apt-get update"],
		}
		
		package { "unzip":
			ensure => present,
			require => Exec["apt-get update"],
		}
}
