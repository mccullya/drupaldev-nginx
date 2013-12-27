#import 'devsites.pp'

group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }

class { 'apt': }

$server_values = hiera('server', false)

ensure_packages( $server_values['packages'] )
