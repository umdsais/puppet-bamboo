# Private class to manage Bamboo installation
#
class bamboo::install {
  $file = "atlassian-bamboo-${bamboo::version}.${bamboo::extension}"

  if $bamboo::manage_user {
    user { $bamboo::user:
      ensure           => 'present',
      comment          => 'Bamboo service account',
      shell            => $bamboo::shell,
      home             => $bamboo::homedir,
      password         => $bamboo::password,
      password_min_age => '0',
      password_max_age => '99999',
      managehome       => true,
      uid              => $bamboo::uid,
      gid              => $bamboo::gid,
    }
  }

  if $bamboo::manage_group {
    group { $bamboo::group:
      ensure => 'present',
      gid    => $bamboo::gid,
    }
  }

  if $bamboo::manage_installdir {
    file { $bamboo::installdir:
      ensure => 'directory',
      owner  => $bamboo::user,
      group  => $bamboo::group,
    }
  }

  if $bamboo::manage_appdir {
    file { $bamboo::real_appdir:
      ensure => 'directory',
      owner  => $bamboo::user,
      group  => $bamboo::group,
      before => Archive[$file],
    }
  }

  file { $bamboo::homedir:
    ensure => 'directory',
    owner  => $bamboo::user,
    group  => $bamboo::group,
    mode   => '0750',
  }

  # If a value for `checksum` is specified, set `checksum_verify` on the `archive` module implicitly.
  if $bamboo::checksum == undef {
    $checksum_verify = false
  } else {
    $checksum_verify = true
  }

  archive { $file:
    source          => "${bamboo::download_url}/${file}",
    path            => "/tmp/${file}",
    extract         => true,
    extract_command => 'tar xzf %s --strip-components=1',
    extract_path    => $bamboo::real_appdir,
    cleanup         => true,
    proxy_server    => $bamboo::proxy_server,
    proxy_type      => $bamboo::proxy_type,
    allow_insecure  => true,
    creates         => "${bamboo::real_appdir}/conf",
    user            => $bamboo::user,
    group           => $bamboo::group,
    checksum_verify => $checksum_verify,
    checksum_type   => $bamboo::checksum_type,
    checksum        => $bamboo::checksum,
  }

  #
  # If the 'bamboo_version' fact is defined (as provided by this module),
  # compare it to the specified version.  If it doesn't match, stop the
  # bamboo service prior to upgrading but after downloading the new version
  #
  if defined('$::bamboo_version') {
    if versioncmp($bamboo::version, $facts['bamboo_version']) > 0 {
      notify { "Updating Bamboo from version ${facts['bamboo_version']} to ${bamboo::version}": }
      exec { $bamboo::stop_command:
        path    => $facts['path'],
        require => Archive[$file],
      }
    }
  }

  file { "${bamboo::homedir}/logs":
    ensure => 'directory',
    owner  => $bamboo::user,
    group  => $bamboo::group,
  }

  exec { "chown_${bamboo::real_appdir}":
    command => "chown -R ${bamboo::user}:${bamboo::group} ${bamboo::real_appdir}",
    unless  => "find ${bamboo::real_appdir} ! -type l \\( ! -user ${bamboo::user} \\) \
      -o \\( ! -group ${bamboo::group} \\) | wc -l | awk '{print \$1}' | grep -qE '^0'",
    path    => '/bin:/usr/bin',
  }
}
