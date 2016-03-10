# == Class bamboo::params
#
# This class is meant to be called from bamboo.
# It sets variables according to platform.
#
class bamboo::params {

  case $::osfamily {
    'Debian': {
      $service_lockfile        = '/var/lock/bamboo'
      if $::operatingsystemmajrelease == '8' {
        $service_file_location = '/usr/lib/systemd/system/bamboo.service'
        $service_file_template = 'bamboo/bamboo.service.erb'
      } elsif $::operatingsystemmajrelease =~ /^7$|^14.04$/ {
        $service_file_location = '/etc/init.d/bamboo'
        $service_file_template = 'bamboo/bamboo.initscript.erb'
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
      }
    }
    'RedHat', 'Amazon': {
      $service_lockfile        = '/var/lock/subsys/bamboo'
      if $::operatingsystemmajrelease == '7' {
        $service_file_location = '/usr/lib/systemd/system/bamboo.service'
        $service_file_template = 'bamboo/bamboo.service.erb'
      } elsif $::operatingsystemmajrelease == '6' {
        $service_file_location = '/etc/init.d/bamboo'
        $service_file_template = 'bamboo/bamboo.initscript.erb'
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
