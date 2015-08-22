# == Class bamboo::install
#
# This class is called from bamboo for install.
#
class bamboo::install {

  user { $::bamboo::bamboo_user:
    ensure     => present,
    comment    => 'Bamboo service account',
    home       => $::bamboo::data_dir,
    managehome => true,
    system     => true,
  }
  file { $::bamboo::install_dir:
    ensure  => directory,
    owner   => $::bamboo::bamboo_user,
    recurse => true,
    require => User[$::bamboo::bamboo_user],
  }
  staging::deploy { "atlassian-bamboo-${::bamboo::version}.tar.gz":
    target  => $::bamboo::install_dir,
    source  => "${::bamboo::download_url}/atlassian-bamboo-${::bamboo::version}.tar.gz",
    user    => $::bamboo::bamboo_user,
    require => File[$::bamboo::install_dir],
  }
  file { "${::bamboo::install_dir}/current":
    ensure  => link,
    target  => "${::bamboo::install_dir}/atlassian-bamboo-${::bamboo::version}",
    require => Staging::Deploy["atlassian-bamboo-${::bamboo::version}.tar.gz"],
  }
  file { $::bamboo::log_dir:
    ensure  => link,
    target  => "${::bamboo::install_dir}/current/logs",
    require => File["${::bamboo::install_dir}/current"],
  }

}
