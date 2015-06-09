# == Class bamboo::service
#
# This class is meant to be called from bamboo.
# It ensures the service is running.
#
class bamboo::service {
  if $::bamboo::service_manage {
    service { $::bamboo::service_name:
      ensure     => $::bamboo::service_ensure,
      enable     => $::bamboo::service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
