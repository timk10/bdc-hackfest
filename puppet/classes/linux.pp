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
    			# onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
		}
	#	exec { "apt-update":
	#		path => "$execpath",
	#		user => root,
	#		command => "apt-get update && touch $aptversionfile",
		#}

		#exec { "apt-update-add-sources":
		#	path => "$execpath",
		#	user => root,
		#	command => "echo deb http://archive.canonical.com/ubuntu lucid partner >> /etc/apt/sources.list",
		#	onlyif => "[ \"`/bin/grep \"^deb http://archive.canonical.com/ubuntu lucid partner\" /etc/apt/sources.list`\" = \"\" ]",
		#}

		#exec { "apt-update-add-backport-source":
		#	path => "$execpath",
		#	user => root,
		#	command => "echo deb http://us.archive.ubuntu.com/ubuntu/ lucid-backports main restricted universe multiverse >> /etc/apt/sources.list",
		#	onlyif => "[ \"`/bin/grep \"^deb http://us.archive.ubuntu.com/ubuntu/ lucid-backports main restricted universe multiverse\" /etc/apt/sources.list`\" = \"\" ]",
		#	require => Exec["apt-update-add-sources"],
		#}

		#if $include_mysql == "true" {
		#	$percona_repo_file = "$puppetdir/percona.version"

		#	#############################
		#	# Add Percona repositories
		#	#############################
		#	exec { "apt-key":
		#		path => "$execpath",
		#		command => "gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A \
		#								&& gpg -a --export CD2EFD2A | apt-key add - && touch $percona_repo_file",
		#		user => root,
		#		timeout => "-1",
		#		creates => "$percona_repo_file",
		#	}

		#	exec { "apt-repo":
		#		path => "$execpath",
		#		user => root,
		#		command => "echo 'deb http://repo.percona.com/apt lucid main' >> /etc/apt/sources.list \
		#								&& echo 'deb-src http://repo.percona.com/apt lucid main' >> /etc/apt/sources.list",
		#		onlyif => "[ \"`/bin/grep \"^deb http://repo.percona.com/apt lucid main\" /etc/apt/sources.list`\" = \"\" ]",
		#		require => Exec["apt-key"],
		#	}

		#	$percona_apt_update = "$puppetdir/perconaapt.version"
		#	exec { "apt-update-percona":
		#		path => "$execpath",
		#		user => root,
		#		command => "apt-get update \
		#								&& touch $percona_apt_update",
		#		require => Exec["apt-repo"],
		#		creates => "$percona_apt_update",
		#	}
		#}
		# Set ROOTPATH environment variable
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

		#package { "sshpass":
		#	ensure => present,
		#	require => Exec["apt-get update"],
		#}
}
