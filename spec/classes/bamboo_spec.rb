require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'bamboo class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          # Class tests
          it { is_expected.to contain_class('bamboo::params') }
          it { is_expected.to contain_class('bamboo::install').that_comes_before('bamboo::config') }
          it { is_expected.to contain_class('bamboo::config') }
          it { is_expected.to contain_class('bamboo::service').that_subscribes_to('bamboo::config') }
          it { is_expected.to contain_class('bamboo').that_requires('bamboo::service') }

          # Install tests
          it { is_expected.to contain_group('bamboo') }
          it { is_expected.to contain_user('bamboo') }
          it { is_expected.to contain_file('/opt/bamboo') }
          it { is_expected.to contain_file('/home/bamboo') }
          it { is_expected.to contain_archive('/tmp/atlassian-bamboo-5.10.2.tar.gz') }
          it { is_expected.to contain_file('/opt/bamboo/atlassian-bamboo-5.10.2/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties') }
          it { is_expected.to contain_ini_setting('/opt/bamboo/atlassian-bamboo-5.10.2/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties  bamboo.home') }
          it { is_expected.to contain_exec('chown_/opt/bamboo/atlassian-bamboo-5.10.2') }

          # Config tests
          it { is_expected.to contain_file('/opt/bamboo/atlassian-bamboo-5.10.2/conf/server.xml') }
          it { is_expected.to contain_file_line('java_home') }
          it { is_expected.to contain_file_line('bamboo_home') }
          it { is_expected.to contain_ini_setting('jvm_minimum_memory') }
          it { is_expected.to contain_ini_setting('jvm_maximum_memory') }
          it { is_expected.to contain_ini_setting('jvm_support_args') }

          it { is_expected.to contain_service('bamboo') }
        end

        context 'bamboo class with parameter overrides' do
          let(:params) do
            {
              'javahome'           => '/etc/alternatives/java',
              'jvm_minimum_memory' => '1G',
              'jvm_maximum_memory' => '3G',
              'jvm_support_args'   => '-XX:-HeapDumpOnOutOfMemoryError',
              'version'            => '5.10.1.1',
              'checksum'           => '435ecc59fd5f226f0a0ecf185d9644f9',
              'format'             => 'tgz',
              'installdir'         => '/install/path',
              'homedir'            => '/home/path',
              'context_path'       => '/bamboo',
              'tomcat_port'        => '8080',
              'user'               => 'custom_user',
              'group'              => 'custom_group',
              'uid'                => '1234',
              'gid'                => '5678',
              'download_url'       => 'http://my.custom.server/path/to/download',
              'stop_bamboo'        => 'service bamboo stop && sleep 30',
              'service_manage'     => false,
              'proxy' => {
                'scheme'    => 'https',
                'proxyName' => 'my.proxy.url',
                'proxyPort' => '443',
              },
            }
          end
          it { is_expected.to compile.with_all_deps }

          # Install tests
          it do
            is_expected.to contain_group('custom_group').with(
              'ensure' => 'present',
              'gid'    => '5678',
            )
          end
          it do
            is_expected.to contain_user('custom_user').with(
              'ensure'     => 'present',
              'comment'    => 'Bamboo daemon account',
              'home'       => '/home/path',
              'managehome' => true,
              'uid'        => '1234',
              'gid'        => '5678',
            ).that_comes_before(
              'File[/install/path]'
            ).that_comes_before(
              'File[/home/path]'
            )
          end
          it do
            is_expected.to contain_file('/install/path').with(
              'ensure' => 'directory',
              'owner'  => 'custom_user',
              'group'  => 'custom_group',
            )
          end
          it do
            is_expected.to contain_file('/home/path').with(
              'ensure' => 'directory',
              'owner'  => 'custom_user',
              'group'  => 'custom_group',
            )
          end
          it do
            is_expected.to contain_archive('/tmp/atlassian-bamboo-5.10.1.1.tgz').with(
              'ensure'        => 'present',
              'extract'       => true,
              'extract_path'  => '/install/path',
              'source'        => 'http://my.custom.server/path/to/download/atlassian-bamboo-5.10.1.1.tgz',
              'creates'       => '/install/path/atlassian-bamboo-5.10.1.1',
              'cleanup'       => true,
              'checksum_type' => 'md5',
              'checksum'      => '435ecc59fd5f226f0a0ecf185d9644f9',
              'user'          => 'custom_user',
              'group'         => 'custom_group',
            ).that_notifies(
              'Exec[chown_/install/path/atlassian-bamboo-5.10.1.1]'
            ).that_requires(
              'File[/install/path]'
            ).that_requires(
              'User[custom_user]'
            )
          end
          it do
            is_expected.to contain_file('/install/path/atlassian-bamboo-5.10.1.1/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties').with(
              'ensure' => 'file',
              'owner'  => 'custom_user',
              'group'  => 'custom_group',
              'mode'   => '0640',
            )
          end
          it do
            is_expected.to contain_ini_setting('/install/path/atlassian-bamboo-5.10.1.1/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties  bamboo.home').with(
              'ensure'            => 'present',
              'path'              => '/install/path/atlassian-bamboo-5.10.1.1/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties',
              'key_val_separator' => '=',
              'section'           => '',
              'setting'           => 'bamboo.home',
              'value'             => '/home/path',
            )
          end
          it do
            is_expected.to contain_exec('chown_/install/path/atlassian-bamboo-5.10.1.1').with(
              'command'     => '/bin/chown -R custom_user:custom_group /install/path/atlassian-bamboo-5.10.1.1',
              'refreshonly' => true,
            )
          end

          # Config tests
          it do
            is_expected.to contain_file('/install/path/atlassian-bamboo-5.10.1.1/conf/server.xml').with(
              'ensure' => 'present',
              'owner'  => 'custom_user',
              'group'  => 'custom_group',
              'mode'   => '0640',
            ).with_content(
              /Connector port=\"8080\"/
            ).with_content(
              /scheme=\"https\"/
            ).with_content(
              /proxyName=\"my.proxy.url\"/
            ).with_content(
              /proxyPort=\"443\"/
            ).with_content(
              /Context path=\"\/bamboo\"/
            )
          end
          it do
            is_expected.to contain_file_line('java_home').with(
              'ensure' => 'present',
              'path'   => '/install/path/atlassian-bamboo-5.10.1.1/bin/setenv.sh',
              'line'   => 'JAVA_HOME=/etc/alternatives/java',
              'match'  => 'JAVA_HOME=',
            )
          end
          it do
            is_expected.to contain_file_line('bamboo_home').with(
              'ensure' => 'present',
              'path'   => '/install/path/atlassian-bamboo-5.10.1.1/bin/setenv.sh',
              'line'   => 'BAMBOO_HOME=/home/path',
              'match'  => '#BAMBOO_HOME=',
            )
          end
          it do
            is_expected.to contain_ini_setting('jvm_minimum_memory').with(
              'ensure'  => 'present',
              'path'    => '/install/path/atlassian-bamboo-5.10.1.1/bin/setenv.sh',
              'section' => '',
              'setting' => 'JVM_MINIMUM_MEMORY',
              'value'   => '1G',
            )
          end
          it do
            is_expected.to contain_ini_setting('jvm_maximum_memory').with(
              'ensure'  => 'present',
              'path'    => '/install/path/atlassian-bamboo-5.10.1.1/bin/setenv.sh',
              'section' => '',
              'setting' => 'JVM_MAXIMUM_MEMORY',
              'value'   => '3G',
            )
          end
          it do
            is_expected.to contain_ini_setting('jvm_support_args').with(
              'ensure'  => 'present',
              'path'    => '/install/path/atlassian-bamboo-5.10.1.1/bin/setenv.sh',
              'section' => '',
              'setting' => 'JVM_SUPPORT_RECOMMENDED_ARGS',
              'value'   => '-XX:-HeapDumpOnOutOfMemoryError',
            )
          end
        end
      end
    end
  end

  context 'when using staging do' do
    context 'with default params' do
      let(:facts) do
        {
          :osfamily                  => 'Debian',
          :operatingsystemmajrelease => '7',
        }
      end
      let(:params) do
        {
          'deploy_module' => 'staging',
        }
      end
      it { is_expected.to contain_staging__file('atlassian-bamboo-5.10.2.tar.gz') }
      it { is_expected.to contain_staging__extract('atlassian-bamboo-5.10.2.tar.gz') }
    end
    context 'with parameter overrides' do
      let(:facts) do
        {
          :osfamily                  => 'Debian',
          :operatingsystemmajrelease => '7',
        }
      end
      let(:params) do
        {
          'deploy_module' => 'staging',
          'version'       => '5.10.1.1',
          'format'        => 'tgz',
          'installdir'    => '/install/path',
          'homedir'       => '/home/path',
          'user'          => 'custom_user',
          'group'         => 'custom_group',
          'download_url'  => 'http://my.custom.server/path/to/download',
        }
      end
      it do
        is_expected.to contain_staging__file('atlassian-bamboo-5.10.1.1.tgz').with(
          'source'  => 'http://my.custom.server/path/to/download/atlassian-bamboo-5.10.1.1.tgz',
          'timeout' => 1800,
        ).that_comes_before('Staging::Extract[atlassian-bamboo-5.10.1.1.tgz]')
      end
      it do
        is_expected.to contain_staging__extract('atlassian-bamboo-5.10.1.1.tgz').with(
          'target'  => '/install/path',
          'creates' => '/install/path/atlassian-bamboo-5.10.1.1',
          'user'    => 'custom_user',
          'group'   => 'custom_group',
        ).that_notifies(
          'Exec[chown_/install/path/atlassian-bamboo-5.10.1.1]'
        ).that_requires(
          'File[/install/path]'
        ).that_requires(
          'User[custom_user]'
        )
      end
    end
  end

  context 'when managing the service' do
    context 'bamboo class without any parameters' do
      context 'on Debian 7' do
        let(:facts) do
          {
            :osfamily                  => 'Debian',
            :operatingsystemmajrelease => '7',
          }
        end

        it do
          is_expected.to contain_file('/etc/init.d/bamboo').with_content(
            /USER=bamboo/
          ).with_content(
            /BASE=\/opt\/bamboo\/atlassian-bamboo-5.10.2/
          ).with_content(
            /JAVA_HOME=\/opt\/java/
          )
        end
      end
      context 'on Debian 8' do
        let(:facts) do
          {
            :osfamily                  => 'Debian',
            :operatingsystemmajrelease => '8',
          }
        end

        it do
          is_expected.to contain_file('/usr/lib/systemd/system/bamboo.service').with_content(
            /User=bamboo/
          ).with_content(
            /ExecStart=\/opt\/bamboo\/atlassian-bamboo-5.10.2\/bin\/start-bamboo.sh/
          ).with_content(
            /ExecStop=\/opt\/bamboo\/atlassian-bamboo-5.10.2\/bin\/stop-bamboo.sh/
          )
        end
        it { is_expected.to contain_exec('refresh_systemd') }
      end
      context 'on RedHat 6' do
        let(:facts) do
          {
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '6',
          }
        end

        it do
          is_expected.to contain_file('/etc/init.d/bamboo').with_content(
            /USER=bamboo/
          ).with_content(
            /BASE=\/opt\/bamboo\/atlassian-bamboo-5.10.2/
          ).with_content(
            /JAVA_HOME=\/opt\/java/
          )
        end
      end
      context 'on RedHat 7' do
        let(:facts) do
          {
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '7',
          }
        end

        it do
          is_expected.to contain_file('/usr/lib/systemd/system/bamboo.service').with_content(
            /User=bamboo/
          ).with_content(
            /ExecStart=\/opt\/bamboo\/atlassian-bamboo-5.10.2\/bin\/start-bamboo.sh/
          ).with_content(
            /ExecStop=\/opt\/bamboo\/atlassian-bamboo-5.10.2\/bin\/stop-bamboo.sh/
          )
        end
        it { is_expected.to contain_exec('refresh_systemd') }
      end
      context 'on Ubuntu 14.04' do
        let(:facts) do
          {
            :osfamily                  => 'Debian',
            :operatingsystemmajrelease => '14.04',
          }
        end

        it do
          is_expected.to contain_file('/etc/init.d/bamboo').with_content(
            /USER=bamboo/
          ).with_content(
            /BASE=\/opt\/bamboo\/atlassian-bamboo-5.10.2/
          ).with_content(
            /JAVA_HOME=\/opt\/java/
          )
        end
      end
    end
    context 'bamboo class with parameter overrides' do
      let(:params) do
        {
          'javahome'       => '/etc/alternatives/java',
          'version'        => '5.10.1.1',
          'format'         => 'tgz',
          'installdir'     => '/install/path',
          'homedir'        => '/home/path',
          'user'           => 'custom_user',
          'service_ensure' => 'stopped',
          'service_enable' => false,
        }
      end
      context 'when not using systemd' do
        let(:facts) do
          {
            :osfamily                  => 'Debian',
            :operatingsystemmajrelease => '7',
          }
        end

        it do
          is_expected.to contain_file('/etc/init.d/bamboo').with_content(
            /USER=custom_user/
          ).with_content(
            /BASE=\/install\/path\/atlassian-bamboo-5.10.1.1/
          ).with_content(
            /JAVA_HOME=\/etc\/alternatives\/java/
          )
        end
        it do
          is_expected.to contain_service('bamboo').with(
            'ensure' => 'stopped',
            'enable' => false,
          )
        end
      end
      context 'when using systemd' do
        let(:facts) do
          {
            :osfamily                  => 'Debian',
            :operatingsystemmajrelease => '8',
          }
        end

        it do
          is_expected.to contain_file('/usr/lib/systemd/system/bamboo.service').with_content(
            /User=custom_user/
          ).with_content(
            /ExecStart=\/install\/path\/atlassian-bamboo-5.10.1.1\/bin\/start-bamboo.sh/
          ).with_content(
            /ExecStop=\/install\/path\/atlassian-bamboo-5.10.1.1\/bin\/stop-bamboo.sh/
          )
        end
        it do
          is_expected.to contain_exec('refresh_systemd').with(
            'command'     => 'systemctl daemon-reload',
            'refreshonly' => true,
            'path'        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
          ).that_subscribes_to(
            'File[/usr/lib/systemd/system/bamboo.service]'
          ).that_comes_before('Service[bamboo]')
        end
        it do
          is_expected.to contain_service('bamboo').with(
            'ensure' => 'stopped',
            'enable' => false,
          )
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'bamboo class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_class('bamboo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
