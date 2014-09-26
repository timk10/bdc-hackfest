# Define global version dir

class java7 {
		package { "openjdk-7-jdk":
			ensure => present,
			require => [Class["linux"]],
		}

}

