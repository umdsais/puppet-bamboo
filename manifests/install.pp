# == Class bamboo::install
#
# This class is called from bamboo for install.
#
class bamboo::install {

  if $::bamboo::manage_user {
    group { $::bamboo::group:
      ensure => present,
      gid    => $::bamboo::gid,
    }

    user { $::bamboo::user:
      ensure     => present,
      comment    => 'Bamboo daemon account',
      home       => $::bamboo::homedir,
      managehome => true,
      uid        => $::bamboo::uid,
      gid        => $::bamboo::gid,
      before     => [ File[$::bamboo::installdir], File[$::bamboo::homedir] ],
    }
  }

  file { [ $::bamboo::installdir, $::bamboo::homedir ]:
    ensure => directory,
    owner  => $::bamboo::user,
    group  => $::bamboo::group,
  }

  case $::bamboo::deploy_module {
    'staging': {
      require ::staging
      staging::file { $::bamboo::file:
        source  => "${::bamboo::download_url}/${::bamboo::file}",
        timeout => 1800,
      } ->
      staging::extract { $::bamboo::file:
        target  => $::bamboo::installdir,
        creates => $::bamboo::webappdir,
        user    => $::bamboo::user,
        group   => $::bamboo::group,
        notify  => Exec["chown_${::bamboo::webappdir}"],
        require => [
          File[$::bamboo::installdir],
          User[$::bamboo::user],
        ],
      }
    }
    'archive': {
      require ::archive
      archive { "/tmp/${::bamboo::file}":
        ensure        => present,
        extract       => true,
        extract_path  => $::bamboo::installdir,
        source        => "${::bamboo::download_url}/${::bamboo::file}",
        creates       => $::bamboo::webappdir,
        cleanup       => true,
        checksum_type => 'md5',
        checksum      => $::bamboo::checksum,
        user          => $::bamboo::user,
        group         => $::bamboo::group,
        notify        => Exec["chown_${::bamboo::webappdir}"],
        require       => [
          File[$::bamboo::installdir],
          User[$::bamboo::user],
        ],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or "staging"')
    }
  }

  $bamboo_properties = "${::bamboo::webappdir}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"

  file { $bamboo_properties:
    ensure  => file,
    owner   => $::bamboo::user,
    group   => $::bamboo::group,
    mode    => '0640',
    require => Exec["chown_${::bamboo::webappdir}"],
  }

  $defaults = {
    'path' => $bamboo_properties,
    'key_val_separator' => '=',
    'require' => File[$bamboo_properties],
  }
  create_ini_settings({ '' => $::bamboo::setup_properties }, $defaults)

  exec { "chown_${::bamboo::webappdir}":
    command     => "/bin/chown -R ${::bamboo::user}:${::bamboo::group} ${::bamboo::webappdir}",
    refreshonly => true,
  }
}
