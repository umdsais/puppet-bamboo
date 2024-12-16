# Private class to manage Bamboo's configuration
#
class bamboo::configure {
  file { "${bamboo::real_appdir}/bin/setenv.sh":
    ensure  => 'file',
    owner   => $bamboo::user,
    group   => $bamboo::group,
    mode    => '0755',
    content => template('bamboo/setenv.sh.erb'),
  }

  file { "${bamboo::real_appdir}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties":
    ensure  => 'file',
    owner   => $bamboo::user,
    group   => $bamboo::group,
    content => "bamboo.home=${bamboo::homedir}",
  }

  $changes = [
    "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path '${bamboo::context_path}'",
    "set Server/Service/Connector/#attribute/maxThreads '${bamboo::max_threads}'",
    "set Server/Service/Connector/#attribute/minSpareThreads '${bamboo::min_spare_threads}'",
    "set Server/Service/Connector/#attribute/connectionTimeout '${bamboo::connection_timeout}'",
    "set Server/Service/Connector/#attribute/port '${bamboo::tomcat_port}'",
    "set Server/Service/Connector/#attribute/acceptCount '${bamboo::accept_count}'",
  ]

  if !empty($bamboo::proxy) {
    $_proxy   = suffix(
      prefix(
        join_keys_to_values($bamboo::proxy, " '"),
        'set Server/Service/Connector[#attribute/protocol = "HTTP/1.1"]/#attribute/'
      ),
      "'"
    )
    $_changes = concat($changes, $_proxy)
  }
  else {
    $_proxy   = undef
    $_changes = $changes
  }

  augeas { "${bamboo::real_appdir}/conf/server.xml":
    lens    => 'Xml.lns',
    incl    => "${bamboo::real_appdir}/conf/server.xml",
    changes => $_changes,
  }
}
