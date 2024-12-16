# Private class to manage Bamboo external facts
#
class bamboo::facts {
  case $bamboo::facts_ensure {
    'absent': { $file_ensure = 'absent' }
    default: { $file_ensure = 'file' }
  }

  if $bamboo::create_facter_dir {
    # Ensure facter's external fact directory exists
    # https://docs.puppet.com/facter/3.5/custom_facts.html#external-facts
    # Not using a file resource to avoid stepping on toes and defined() is
    # parse-order dependent.
    exec { "bamboo_${bamboo::facter_dir}":
      command => "/bin/mkdir -p '${bamboo::facter_dir}'",
      creates => $bamboo::facter_dir,
      before  => File["${bamboo::facter_dir}/bamboo_facts.txt"],
    }
  }

  file { "${bamboo::facter_dir}/bamboo_facts.txt":
    ensure  => $file_ensure,
    content => "bamboo_version=${bamboo::version}",
    mode    => '0444',
  }

  # When using the newer external facts directory, ensure the bamboo facts
  # under /etc/puppetlabs/facter/facts.d/ are absent.
  if ($bamboo::facter_dir == '/opt/puppetlabs/facter/facts.d') {
    file { '/etc/puppetlabs/facter/facts.d/bamboo_facts.txt':
      ensure => 'absent',
    }
  }
}
