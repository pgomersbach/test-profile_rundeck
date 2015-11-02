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
  if $::ec2_public_ipv4 != undef {
    $public_hostname = $::ec2_public_ipv4
  }
  else 
  {
    if $::ec2_metadata != undef {
      $public_hostname = $::facts['ec2_metadata']['public-hostname']
    }
    else {
      $public_hostname = $::fqdn
    }
  }

  include java
  class { 'rundeck':
    framework_config => {
      'framework.server.url' => "http://${public_hostname}:4440",
    },
  }

  rundeck::config::project { 'management':
    file_copier_provider   => 'script-copy',
    node_executor_provider => 'script-exec',
  }

  ini_setting { 'management::plugin.script-exec.default.command':
    ensure  => present,
    path    => '/var/lib/rundeck/projects/management/etc/project.properties',
    section => '',
    setting => 'plugin.script-exec.default.command',
    value   => '/opt/puppetlabs/bin/mco shell run --np --dt 1 -I /${node.name}/ \'${exec.command}\'',
    require => Rundeck::Config::Project[ 'management' ],
  }

  ini_setting { 'management::plugin.script-copy.default.command':
    ensure  => present,
    path    => '/var/lib/rundeck/projects/management/etc/project.properties',
    section => '',
    setting => 'plugin.script-copy.default.command',
    value   => 'boo /${node.name}/ \'${exec.command}\'',
    require => Rundeck::Config::Project[ 'management' ],
  }

  rundeck::config::resource_source { 'resource':
    project_name        => 'management',
    number              => '1',
    source_type         => 'url',
    url                 => 'http://localhost:4567/api/xml',
    url_cache           => false,
    include_server_node => false,
  }

  package { 'puppetdb_rundeck':
    ensure   => installed,
    provider => gem,
  }

  file { '/var/lib/rundeck/libext/rundeck-json-plugin-1.1.jar':
    source => 'puppet:///modules/profile_rundeck/rundeck-json-plugin-1.1.jar'
  }

  file { '/var/lib/rundeck/libext/rundeck-mcollective-nodes-1.1-plugin.zip':
    source => 'puppet:///modules/profile_rundeck/rundeck-mcollective-nodes-1.1-plugin.zip',
  }
}
