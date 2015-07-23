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

  ini_setting { 'management::plugin.script-exec.default.command':
    ensure  => present,
    path    => '/var/lib/rundeck/projects/management/etc/project.properties',
    section => '',
    setting => 'plugin.script-exec.default.command',
    value   => '/usr/bin/mco shell run --np --dt 1 -I /${node.name}/ \'${exec.command}\'',
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

  rundeck::config::plugin { 'mcollective-plugin':
    name   => 'rundeck-mcollective-nodes-1.1-plugin.zip',
    source => 'https://github.com/connaryscott/rundeck-mcollective-nodes/raw/master/dist/rundeck-mcollective-nodes-1.1-plugin.zip',
  }

}
