# Manage Atlassian Bamboo
#
# Refer to the README at the root of this module for documentation
#
# @param version
#   The version of Bamboo to ensure is installed.
#   Expects a value like `9.6.7`
#
# @param extension
#   The file extension of the download archive.
#   Valid values: `'tar.gz'` or `'.zip'`
#   Defaults to `tar.gz`
#
# @param manage_installdir
#   Toggles whether the module should manage the `installdir`
#   Defaults to `true`
#
# @param installdir
#   The absolute path to the "base" directory that will contain the installation.
#   The installation will be in a sub-directory of this (see `appdir`)
#   Defaults to `/usr/local/bamboo`
#
# @param manage_appdir
#   Toggles whether the `appdir` should be managed by this module.
#   Defaults to `true`
#
# @param appdir
#   The absolute path to the installation. This should be a sub-directory of the `installdir`.
#   In most cases, you shouldn't need to specify this.
#   Defaults to `${installdir}/atlassian-bamboo-${version}`
#
# @param homedir
#   The absolute path to the Bamboo user's home directory.
#   Defaults to `/var/local/bamboo`
#
# @param context_path
#   Specifies an optional context path to serve Bamboo from.
#   For example, `/bamboo` if the URL is 'https://example.org/bamboo'
#   Defaults to ''
#
# @param tomcat_port
#   The TCP port that Bamboo's internal Tomcat instance should listen on.
#   This configures the HTTP connector in `server.xml`
#   Defaults to `8085`
#
# @param max_threads
#   Specifies the `maxThreads` attribute value on Bamboo's internal Tomcat instance HTTP connector.
#   Defaults to `150`
#
# @param min_spare_threads
#   Specifies the `maxSpareThreads` attribute value on Bamboo's internal Tomcat instance HTTP connector.
#   Defaults to `25`
#
# @param connection_timeout
#   Specifies the `connectionTimeout` attribute value on Bamboo's internal Tomcat instance HTTP connector.
#   Defaults to `20000`
#
# @param accept_count
#   Specifies the `acceptCount` attribute value on Bamboo's internal Tomcat instance HTTP connector.
#   Defaults to `100`
#
# @param proxy
#   A hash of key/value pairs to configure proxy settings on Bamboo's internal Tomcat instance HTTP connector.
#   Defaults to `{}`
#
# @param manage_user
#   Toggles whether the `user` should be managed by this module.
#   Defaults to `true`
#
# @param manage_group
#   Toggles whether the `group` should be managed by this module.
#   Defaults to `true`
#
# @param user
#   Specifies the user that should own and run Bamboo.
#   Defaults to `bamboo`
#
# @param group
#   Specifies the group that should own and run Bamboo.
#   Defaults to `bamboo`
#
# @param uid
#   Specifies a UID to use for the `user` if `manage_user=true`.
#   Defaults to `undef`
#
# @param gid
#   Specifies a GID to use for the `group` if `manage_group=true`.
#   Defaults to `undef`
#
# @param password
#   Specifies a password for the `user` if `manage_user=true`
#   Defaults to `*` (no password)
#
# @param shell
#   The absolute path to the `user` shell if `manage_user=true`
#   Defaults to `/bin/bash`
#
# @param java_home
#   The absolute path to a Java installation to use for the `JAVA_HOME` to run Bamboo with.
#   Defaults to `/usr/lib/jvm/java`
#
# @param jvm_xms
#   The value for the `-Xms` argument to start the Bamboo JVM with. This is the starting heap size.
#   Defaults to `256m`
#
# @param jvm_xmx
#   The value for the `-Xmx` argument to start the Bamboo JVM with. This is the maximum heap size.
#   Defaults to `1024m`
#
# @param jvm_opts
#   Specifies any custom options to start the Bamboo JVM with.
#   The value is prefixed to the `JAVA_OPTS` environment variable in Bamboo's `setenv.sh`
#   Defaults to `''` (none)
#
# @param jvm_optional
#   From Bamboo's default `setenv.sh`:
#       Occasionally Atlassian Support may recommend that you set some specific JVM
#       arguments.  You can use this variable below to do that.
#   This sets the value of the `JVM_SUPPORT_RECOMMENDED_ARGS` environment variable in Bamboo's `setenv.sh`
#   Defaults to `''` (none)
#
# @param download_url
#   The base URL to the archive download.
#   Defaults to `https://www.atlassian.com/software/bamboo/downloads/binary`
#
# @param manage_service
#   Toggles whether the module should manage a service resource for Bamboo.
#   Defaults to `true`
#
# @param service_ensure
#   The value for the `ensure` parameter on the Service resource if `manage_service=true`
#   Defaults to `running`
#
# @param service_enable
#   The value for the `enable` parameter on the Service resource if `manage_service=true`
#   Toggles whether the service should be started on boot.
#   Defaults to `true`
#
# @param service_file
#   The absolute path to where the init script or service file should be placed.
#   Defaults depend on operating system. Refer to `params.pp`
#
# @param service_file_mode
#   The file mode of the `service_file` (init script or systemd service file).
#   Defaults depend on operating system. Refer to `params.pp`
#
# @param service_template
#   Template for the init script/service definition.  The module includes an init
#   script and systemd service configuration, but you can use your own if you'd
#   like.  This should refer to a Puppet module template. E.g.
#   `modulename/bamboo.init.erb`
#   Defaults depend on operating system. Refer to `params.pp`
#
# @param service_provider
#   Specifies the provider to use on the Service resource if `manage_service=true`.
#   Defaults to `undef` (using Puppet defaults)
#
# @param reload_systemd
#   Toggles whether systemd should be reloaded via an Exec resource that executes `systemctl daemon-reload` if the service
#   file changes.
#   Only applies if `manage_service=true`
#   Defaults to `true` on systems that use systemd. Refer to `params.pp` for defaults.
#
# @param shutdown_wait
#   Specifies a value, in seconds, to wait for the service to stop in the init script.
#   Does not apply to systems that use systemd.
#   Defaults to `20`
#
# @param initconfig_manage
#   Toggles whether an optional environment file should be managed.
#   This can be used to pass environment variables to Bamboo. It will be sourced by the
#   init script or systemd service file.
#   Defaults to `false`
#
# @param initconfig_path
#   The absolute path to where the init/service config/environment file should be placed.
#   Only applies if `initconfig_manage=true`
#   Defaults depend on operating system. Refer to `params.pp`
#
# @param initconfig_content
#   Specifies a string of content to place in the `initconfig_path` file for service/init
#   configuration.
#   Only applies if `initconfig_manage=true`
#   Defaults to `''`
#
# @param facts_ensure
#   Toggles whether the module should manage an external fact to return the version of Bamboo.
#   If this fact is available, the module can upgrade Bamboo in-place.
#   Defaults to `present`
#
# @param facter_dir
#   Specifies the absolute path to Puppet's Facter external fact directory.
#   Default value depends on the version of facter. Refer to `params.pp`
#
# @param create_facter_dir
#   Toggles whether this module should ensure the external fact directory is created (`facter_dir`).
#   This uses a unique `Exec` resource to recursively create it (`mkdir -p`) to avoid colliding
#   with other potential resources that manage it.
#   Defaults to `true`
#
# @param stop_command
#   Specifies the command to execute prior to upgrading.  This should stop any running
#   Bamboo instance. This gets executed if the `version` parameter does not match the `bamboo_version`
#   fact if `facts_ensure=true`
#   
#   This requires `facts_ensure=true` to provide the `bamboo_version` fact.
#
# @param umask
#   Specifies an optional `UMASK` to run Bamboo with. This sets a `UMASK` environment variable.
#   Defaults to `undef`
#
# @param proxy_server
#   Specifies an optional proxy server to use on the `archive` resource for downloading Bamboo.
#   Example: `https://example.com:8080`
#   Defaults to `undef`
#
# @param proxy_type
#   Specifies the `proxy_type` parameter on the `archive` resource for downloading Bamboo.
#   Valid values: `(none|http|https|ftp)`
#   Defaults to `undef`
#
# @param checksum
#   Specifies the `checksum` parameter on the `archive` resource for downloading Bamboo.
#   If this is set, the downloaded archive's checksum will be compared to this value.
#   (matches `checksum_type`)
#   Defaults to `undef` (will not be checked)
#
# @param checksum_type
#   Specifies the `checksum_type` parameter on the `archive` resource for downloading Bamboo.
#   Valid values: `(none|md5|sha1|sha2|sha256|sha384|sha512)`
#   Defaults to `md5`
#
class bamboo (
  Pattern[/^\d+\.\d+\.\d+(\.\d+)?$/]     $version               = '9.6.7',
  Enum['tar.gz', 'zip']                  $extension             = 'tar.gz',
  Boolean                                $manage_installdir     = true,
  Stdlib::Unixpath                       $installdir            = '/usr/local/bamboo',
  Boolean                                $manage_appdir         = true,
  Optional[Stdlib::Unixpath]             $appdir                = undef,
  Stdlib::Unixpath                       $homedir               = '/var/local/bamboo',
  String                                 $context_path          = '',
  Variant[Pattern[/^\d+$/],Stdlib::Port] $tomcat_port           = 8085,
  Variant[Pattern[/^\d+$/],Integer]      $max_threads           = 150,
  Variant[Pattern[/^\d+$/],Integer]      $min_spare_threads     = 25,
  Variant[Pattern[/^\d+$/],Integer]      $connection_timeout    = 20000,
  Variant[Pattern[/^\d+$/],Integer]      $accept_count          = 100,
  Optional[Hash]                         $proxy                 = {},
  Boolean                                $manage_user           = true,
  Boolean                                $manage_group          = true,
  Pattern[/^[a-z_][a-z0-9_-]*[$]?$/]     $user                  = 'bamboo',
  Pattern[/^[a-z_][a-z0-9_-]*[$]?$/]     $group                 = 'bamboo',
  Variant[Undef,String,Integer]          $uid                   = undef,
  Variant[Undef,String,Integer]          $gid                   = undef,
  String                                 $password              = '*',
  Stdlib::Unixpath                       $shell                 = '/bin/bash',
  Stdlib::Unixpath                       $java_home             = '/usr/lib/jvm/java',
  Pattern[/^\d+(m|g)$/]                  $jvm_xms               = '256m',
  Pattern[/^\d+(m|g)$/]                  $jvm_xmx               = '1024m',
  String                                 $jvm_opts              = '',
  Optional[String]                       $jvm_optional          = '',
  Stdlib::Httpurl                        $download_url          = 'https://www.atlassian.com/software/bamboo/downloads/binary',
  Boolean                                $manage_service        = true,
  Stdlib::Ensure::Service                $service_ensure        = 'running',
  Boolean                                $service_enable        = true,
  Stdlib::Unixpath                       $service_file          = $bamboo::params::service_file,
  Stdlib::Filemode                       $service_file_mode     = $bamboo::params::service_file_mode,
  Pattern[/^(\w+)\/([\/\.\w\s]+)$/]      $service_template      = $bamboo::params::service_template,
  Optional[String]                       $service_provider      = undef,
  Boolean                                $reload_systemd        = $bamboo::params::reload_systemd,
  Variant[Pattern[/^\d+$/],Integer]      $shutdown_wait         = 20,
  Boolean                                $initconfig_manage     = false,
  Stdlib::Unixpath                       $initconfig_path       = $bamboo::params::initconfig_path,
  Optional[String]                       $initconfig_content    = '',
  Enum['present', 'absent']              $facts_ensure          = 'present',
  Stdlib::Unixpath                       $facter_dir            = $bamboo::params::facter_dir,
  Boolean                                $create_facter_dir     = true,
  String                                 $stop_command          = $bamboo::params::stop_command,
  Variant[Undef,Pattern[/^\d+$/]]        $umask                 = undef,
  Optional[String]                       $proxy_server          = undef,
  Optional[String]                       $proxy_type            = undef,
  Optional[String]                       $checksum              = undef,
  Optional[Pattern[/^(none|md5|sha1|sha2|sha256|sha384|sha512)$/]] $checksum_type = 'md5',
) inherits bamboo::params {

  # Set a default value for the appdir.
  if $appdir == undef or $appdir == '' {
    $real_appdir = "${installdir}/atlassian-bamboo-${version}"
  } else {
    $real_appdir = $appdir
  }

  contain 'bamboo::install'
  contain 'bamboo::facts'
  contain 'bamboo::configure'
  contain 'bamboo::service'

  Class['bamboo::install']
  -> Class['bamboo::facts']
  -> Class['bamboo::configure']
  ~> Class['bamboo::service']

}
