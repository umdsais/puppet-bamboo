# == Class: bamboo
#
# Full description of class bamboo here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class bamboo (
  $bamboo_user    = $::bamboo::params::bamboo_user,
  $version        = $::bamboo::params::version,
  $download_url   = $::bamboo::params::download_url,
  $install_dir    = $::bamboo::params::install_dir,
  $data_dir       = $::bamboo::params::data_dir,
  $log_dir        = $::bamboo::params::log_dir,
  $service_manage = $::bamboo::params::service_manage,
  $service_ensure = $::bamboo::params::service_ensure,
  $service_enable = $::bamboo::params::service_enable,
  $java_home      = $::bamboo::params::java_home,
  $jvm_options    = $::bamboo::params::jvm_options,
  $jvm_permgen    = $::bamboo::params::jvm_permgen,
  $jvm_xms        = $::bamboo::params::jvm_xms,
  $jvm_xmx        = $::bamboo::params::jvm_xmx,
  $shutdown_port  = $::bamboo::params::shutdown_port,
  $tomcat_port    = $::bamboo::params::tomcat_port,
  $max_threads    = $::bamboo::params::max_threads,
  $accept_count   = $::bamboo::params::accept_count,
  $https_proxy    = $::bamboo::params::https_proxy,
  $tomcat_ajp     = $::bamboo::params::tomcat_ajp,
  $tomcat_ssl     = $::bamboo::params::tomcat_ssl,
  $service_name   = $::bamboo::params::service_name,
) inherits ::bamboo::params {

  validate_string( $bamboo_user )
  validate_string( $version )
  validate_absolute_path( $install_dir )
  validate_absolute_path( $data_dir )
  validate_bool( $service_manage )
  validate_bool( $service_enable )
  validate_absolute_path( $java_home )
  validate_string( $jvm_options )
  validate_string( $jvm_permgen )
  validate_string( $jvm_xms )
  validate_string( $jvm_xmx )
  validate_string( $shutdown_port )
  validate_string( $tomcat_port )
  validate_string( $max_threads )
  validate_string( $accept_count )

  class { '::bamboo::install': } ->
  class { '::bamboo::config': } ~>
  class { '::bamboo::service': } ->
  Class['::bamboo']
}
