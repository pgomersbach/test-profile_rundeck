# == Class profile_rundeck::params
#
# This class is meant to be called from profile_rundeck.
# It sets variables according to platform.
#
class profile_rundeck::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'profile_rundeck'
      $service_name = 'profile_rundeck'
    }
    'RedHat', 'Amazon': {
      $package_name = 'profile_rundeck'
      $service_name = 'profile_rundeck'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
