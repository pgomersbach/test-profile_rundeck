# == Class: profile_rundeck
#
# Full description of class profile_rundeck here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_rundeck (
  $puppetdb_host = 'localhost',
  $puppetdb_port = '8080',
  $port = '4567',
){
  class { 'rundeck': }

  rundeck::config::project { 'management':
    file_copier_provider   => 'stub',
    node_executor_provider => 'stub',
  }

  package { 'puppetdb_rundeck':
    ensure   => installed,
    provider => gem,
  }

  case downcase($osfamily) {
    'debian': {
      $content = template('profile_rundeck/debian_service.erb')
    }
    'redhat': {
      $content = template('profile_rundeck/redhat_service.erb')
    }
    default: {}
  }

  file { '/etc/init.d/puppetdb_rundeck':
    ensure  => present,
    content => $content,
    owner   => root,
    group   => root,
    mode    => '0755',
    notify  => Service['puppetdb_rundeck']
  }

  service { 'puppetdb_rundeck':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/init.d/puppetdb_rundeck']
  }
}
