group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }

$server_values = hiera('server', false)

ensure_packages( $server_values['packages'] )

class {'apt':
  always_apt_update => true,
}

apt::ppa { 'ppa:rip84/php5': }
