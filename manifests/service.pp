# == Class profile_rundeck::service
#
# This class is meant to be called from profile_rundeck.
# It ensure the service is running.
#
class profile_rundeck::service {

  service { $::profile_rundeck::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
