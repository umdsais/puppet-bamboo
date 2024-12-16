# Private class to manage Bamboo service
#
class bamboo::service {
  if $bamboo::initconfig_manage {
    file { $bamboo::initconfig_path:
      ensure  => 'file',
      content => $bamboo::initconfig_content,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
    }

    if $bamboo::manage_service {
      File[$bamboo::initconfig_path] ~> Service['bamboo']
    }
  }

  file { $bamboo::service_file:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => $bamboo::service_file_mode,
    content => template($bamboo::service_template),
  }

  if $bamboo::manage_service {
    if $bamboo::reload_systemd {
      exec { 'bamboo-refresh_systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/bin:/sbin:/usr/bin:/usr/sbin',
        subscribe   => File[$bamboo::service_file],
        before      => Service['bamboo'],
      }
    }

    service { 'bamboo':
      ensure    => $bamboo::service_ensure,
      enable    => $bamboo::service_enable,
      provider  => $bamboo::service_provider,
      subscribe => File[$bamboo::service_file],
    }
  }
}
