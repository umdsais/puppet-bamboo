# == Class bamboo::config
#
# This class is called from bamboo for service config.
#
class bamboo::config {
  file { "${::bamboo::install_dir}/current/conf/server.xml":
    ensure  => file,
    owner   => $::bamboo::bamboo_user,
    content => template('bamboo/server.xml.erb'),
  }
  file { "${::bamboo::install_dir}/current/bin/setenv.sh":
    ensure  => file,
    mode    => '0755',
    owner   => $::bamboo::bamboo_user,
    content => template('bamboo/setenv.sh.erb'),
  }
  file { "/etc/init.d/${::bamboo::service_name}":
    ensure  => file,
    mode    => '0755',
    content => template('bamboo/bamboo.init.erb'),
  }
}
