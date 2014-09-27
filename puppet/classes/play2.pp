# Define global version dir

$usrdir = "/home/vagrant"
$activator = "activator-1.2.10-minimal"
$play2version = "$puppetdir/play2download.version"
$play2unzip = "$puppetdir/play2unzip.version"
$play2link = "$puppetdir/play2link.version"

class play2 {
	
	exec { "play2 download":
		path => "$execpath",
    	command => "wget -O /tmp/$activator.zip http://downloads.typesafe.com/typesafe-activator/1.2.10/typesafe-$activator.zip && cp /tmp/$activator.zip $usrdir/$activator.zip && touch $play2version",
		require => [Class["linux"]],
        creates => "$play2version",
        user => root,
	}
	
	exec { "play2 unzip":
		path => "$execpath",
    	command => "unzip -o $usrdir/$activator.zip && mv $usrdir/$activator $installdir/$activator && touch $play2unzip",
		require => Exec["play2 download"],
        creates => "$play2unzip",
        user => root,
	}
	
	exec { "play2 link":
		path => "$execpath",
    	command => "ln -s $installdir/$activator/activator /usr/local/bin/activator && touch $play2link",
        creates => "$play2link",
		require => Exec["play2 unzip"],
	}

}

