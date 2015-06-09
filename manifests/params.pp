# == Class bamboo::params
#
# This class is meant to be called from bamboo.
# It sets variables according to platform.
#
class bamboo::params {
  $bamboo_user    = 'bamboo'
  $version        = '5.8.1'
  $download_url   = "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${version}.tar.gz"
  $install_dir    = '/opt/bamboo'
  $data_dir       = '/var/bamboo'
  $log_dir        = '/var/log/bamboo'
  $service_manage = true
  $service_ensure = running
  $service_enable = true

  $java_home      = '/etc/alternatives/java_sdk'
  $jvm_options    = '-XX:-HeapDumpOnOutOfMemoryError'
  $jvm_permgen    = '256m'
  $jvm_xms        = '256m'
  $jvm_xmx        = '384m'

  $shutdown_port  = '8007'
  $tomcat_port    = '8085'
  $max_threads    = '150'
  $accept_count   = '100'
  $https_proxy    = undef
  $tomcat_ajp     = undef
  $tomcat_ssl     = undef

  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $service_name = 'bamboo'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
