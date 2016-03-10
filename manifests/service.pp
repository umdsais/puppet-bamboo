# == Class bamboo::service
#
# This class is meant to be called from bamboo for service management.
#
class bamboo::service {
  if $::bamboo::service_manage {
    file { $::bamboo::service_file_location:
      content => template($::bamboo::service_file_template),
      mode    => '0755',
    }

    if $::bamboo::service_file_location =~ /systemd/ {
      exec { 'refresh_systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File[$::bamboo::service_file_location],
        before      => Service['bamboo'],
        path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      }
    }

    service { 'bamboo':
      ensure  => $::bamboo::service_ensure,
      enable  => $::bamboo::service_enable,
      require => File[$::bamboo::service_file_location],
    }
  }
}
