# Class: hosts::config
#
# Versioned /etc/hosts file.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   include hosts::config

class hosts::config {
    include hosts::params

    file {
        '/etc/hosts':
            ensure => file,
            owner  => 'root',
            group  => 'root',
            mode   => '0644';
    }

    if $::hosts_version != $hosts::params::tmpl_version {
        
	exec { 'tmp_hosts':
   		path    => ['/usr/bin', '/bin'],
    		command => 'cp -rfp /etc/hosts /tmp/hosts',
	}

	exec { 'custom_hosts':
                path    => ['/usr/bin', '/bin'],
                command => "sed -i '0,/# Custom/d' /tmp/hosts",
		require => Exec['tmp_hosts'],
        }

        File['/etc/hosts'] {
        	content => template('hosts/hosts.erb'),
		require => Exec['custom_hosts'],
		before  => Exec['append_hosts'],
        }

	exec { 'append_hosts':
                path    => ['/usr/bin', '/bin'],
                command => 'sed -i "/# Custom/r /tmp/hosts" /etc/hosts',
        }

    }
}

