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
  # JVM settings
  $javahome           = '/opt/java',
  $jvm_minimum_memory = '256m',
  $jvm_maximum_memory = '384m',
  $jvm_support_args   = '',

  # Bamboo settings
  $version      = '5.10.2',
  $checksum     = '1f8ec63b3165de2f58c94251588769d6',
  $format       = 'tar.gz',
  $installdir   = '/opt/bamboo',
  $homedir      = '/home/bamboo',
  $context_path = '',
  $tomcat_port  = 8085,

  # User and Group management settings
  $manage_user = true,
  $user        = 'bamboo',
  $group       = 'bamboo',
  $uid         = undef,
  $gid         = undef,

  # Misc settings
  $download_url  = 'https://www.atlassian.com/software/bamboo/downloads/binary',
  $deploy_module = 'archive',

  # Service settings
  $service_manage = true,
  $service_ensure = running,
  $service_enable = true,

  # Reverse https proxy
  $proxy = {},

  # Command to stop bamboo in preparation to upgrade.
  $stop_bamboo = 'service bamboo stop && sleep 15',

) inherits ::bamboo::params {

  validate_absolute_path($javahome)
  validate_string($jvm_minimum_memory)
  validate_string($jvm_maximum_memory)
  validate_string($jvm_support_args)

  validate_string($version)
  validate_string($checksum)
  validate_string($format)
  validate_absolute_path($installdir)
  validate_absolute_path($homedir)
  validate_string($context_path)
  validate_integer($tomcat_port)

  validate_bool($manage_user)
  validate_string($user)
  validate_string($group)

  validate_string($download_url)
  validate_re($deploy_module, [ '^archive', '^staging' ])

  validate_bool($service_manage)
  validate_re($service_ensure, [ '^running', '^stopped' ])
  validate_bool($service_enable)

  validate_hash($proxy)

  validate_string($stop_bamboo)

  $webappdir = "${installdir}/atlassian-bamboo-${version}"
  $file = "atlassian-bamboo-${version}.${format}"
  $setup_properties = {
    'bamboo.home' => $homedir,
  }

  class { '::bamboo::install': } ->
  class { '::bamboo::config': } ~>
  class { '::bamboo::service': } ->
  Class['::bamboo']
}
