# == Class profile_rundeck::install
#
# This class is called from profile_rundeck for install.
#
class profile_rundeck::install {

  package { $::profile_rundeck::package_name:
    ensure => present,
  }
}
