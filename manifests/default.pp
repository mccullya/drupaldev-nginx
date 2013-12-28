group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }

$server_values = hiera('server', false)

ensure_packages( $server_values['packages'] )

class {'apt':
  always_apt_update => true,
}

apt::ppa { 'ppa:rip84/php5': }

class { 'rvm': version => '1.25.7' }

rvm::system_user { vagrant: }

rvm_system_ruby {
  'ruby-1.9.3-p484':
  ensure => 'present',
  default_use => true;
}

class { 'nginx': }

class { 'php':
  package             => 'php5-fpm',
  service             => 'php5-fpm',
  service_autorestart => false,
  config_file         => '/etc/php5/fpm/php.ini',
  module_prefix       => '',
  require             => Class["apt"],
}

php::module {
  [
  'php5-mysql',
  'php5-cli',
  'php5-curl',
  'php5-intl',
  'php5-mcrypt',
  'php5-gd',
  'php-apc',
  'php5-memcached'
  ]:
  notify  => Service["php5-fpm"]
}

service { 'php5-fpm':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Package['php5-fpm'],
}

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

class { 'xdebug':
  service => 'nginx',
}

#class { 'composer':
#  require => Package['php5-fpm', 'curl'],
#}

class { '::mysql::server':
  root_password => 'drupaldev'
}

php::pear::module { 'drush-6.0.0RC4':
  repository  => 'pear.drush.org',
  use_package => 'no',
}

php::pear::module { 'Console_Table':
  use_package => 'no',
}

#class { 'ruby':
#  gems_version  => 'latest'
#}
#
#package { [
#  'compass',
#]:
#  provider => 'gem',
#  ensure   => 'installed',
#  require  => Package[[rubygems]]
#}

class { 'mailcatcher': }

class { 'xhprof': }
