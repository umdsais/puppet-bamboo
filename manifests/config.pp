# == Class bamboo::config
#
# This class is called from bamboo for service config.
#
class bamboo::config {
  file { "${::bamboo::webappdir}/conf/server.xml":
    ensure  => present,
    content => template('bamboo/server.xml.erb'),
    owner   => $::bamboo::user,
    group   => $::bamboo::group,
    mode    => '0640',
  }

  # setenv.sh settings
  file_line {'bamboo_java_home':
    ensure => present,
    path   => "${::bamboo::webappdir}/bin/setenv.sh",
    line   => "JAVA_HOME=${::bamboo::javahome}",
    match  => 'JAVA_HOME=',
  }

  file_line {'bamboo_home':
    ensure => present,
    path   => "${::bamboo::webappdir}/bin/setenv.sh",
    line   => "BAMBOO_HOME=${::bamboo::homedir}",
    match  => '#BAMBOO_HOME=',
  }

  ini_setting { 'bamboo_jvm_minimum_memory':
    ensure  => present,
    path    => "${::bamboo::webappdir}/bin/setenv.sh",
    section => '',
    setting => 'JVM_MINIMUM_MEMORY',
    value   => $::bamboo::jvm_minimum_memory,
  }

  ini_setting { 'bamboo_jvm_maximum_memory':
    ensure  => present,
    path    => "${::bamboo::webappdir}/bin/setenv.sh",
    section => '',
    setting => 'JVM_MAXIMUM_MEMORY',
    value   => $::bamboo::jvm_maximum_memory,
  }

  ini_setting { 'bamboo_jvm_support_args':
    ensure  => present,
    path    => "${::bamboo::webappdir}/bin/setenv.sh",
    section => '',
    setting => 'JVM_SUPPORT_RECOMMENDED_ARGS',
    value   => $::bamboo::jvm_support_args,
  }
}
