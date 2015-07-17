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
    file_copier_provider   => 'script-copy',
    node_executor_provider => 'script-exec',
  }

  rundeck::config::resource_source { 'resource':
    project_name        => 'management',
    number              => '1',
    source_type         => 'url',
    url                 => 'http://localhost:4567',
    url_cache           => false,
    include_server_node => false,
    resource_format     => 'resourceyaml',
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
