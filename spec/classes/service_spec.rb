require 'spec_helper'

describe 'bamboo' do
  describe 'bamboo::service' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'bamboo::service class with default parameters' do
            case facts[:osfamily]
            when 'RedHat'
              if facts[:operatingsystemmajrelease].to_i >= 7
                systemd = true
                systemd_file = '/usr/lib/systemd/system/bamboo.service'
              end
            when 'Debian'
              if facts[:operatingsystem].casecmp('ubuntu').zero?
                if facts[:operatingsystemmajrelease].to_i >= 16
                  systemd = true
                  systemd_file = '/lib/systemd/system/bamboo.service'
                end
              end
              if facts[:operatingsystem].casecmp('debian').zero?
                if facts[:operatingsystemmajrelease].to_i == 8
                  systemd = true
                  systemd_file = '/lib/systemd/system/bamboo.service'
                end
                if facts[:operatingsystemmajrelease].to_i >= 9
                  systemd = true
                  systemd_file = '/etc/systemd/system/bamboo.service'
                end
              end
            end

            if systemd == true
              it do
                is_expected.to contain_file(systemd_file)
                  .with_content(%r{^PIDFile=\/usr\/local\/bamboo\/atlassian-bamboo-#{BAMBOO_VERSION}\/bin\/Catalina\.pid$}o)
                  .with_content(%r{^Environment=CATALINA_PID=\/usr\/local\/bamboo\/atlassian-bamboo-#{BAMBOO_VERSION}\/bin\/Catalina\.pid$}o)
                  .with_content(%r{^Environment="UMASK="$})
                  .with_content(%r{^SuccessExitStatus=143$})
              end

              it do
                is_expected.to contain_exec('bamboo-refresh_systemd')
              end
            else
              it do
                is_expected.to contain_file('/etc/init.d/bamboo')
                  .with_content(%r{^export CATALINA_HOME=\/usr\/local\/bamboo\/atlassian-bamboo-#{BAMBOO_VERSION}$}o)
                  .with_content(%r{^export UMASK=$})
              end
            end

            it do
              is_expected.to contain_service('bamboo').with(
                ensure: 'running',
                enable: true,
              )
            end
          end

          context 'bamboo::service class with custom umask' do
            let(:params) do
              {
                umask: '0022',
              }
            end

            case facts[:osfamily]
            when 'RedHat'
              if facts[:operatingsystemmajrelease].to_i >= 7
                it do
                  is_expected.to contain_file('/usr/lib/systemd/system/bamboo.service')
                    .with_content(%r{^Environment="UMASK=0022"$})
                end
              else
                it do
                  is_expected.to contain_file('/etc/init.d/bamboo')
                    .with_content(%r{^export UMASK=0022$})
                end
              end
            end
          end

          context 'bamboo::service class with initconfig_manage' do
            let(:params) do
              {
                initconfig_manage: true,
                initconfig_content: 'TEST_VAR=foo',
              }
            end

            if facts[:osfamily] == 'RedHat'
              it do
                is_expected.to contain_file('/etc/sysconfig/bamboo')
                  .with_content(%r{^TEST_VAR=foo$})
                  .that_notifies('Service[bamboo]')
              end
            end

            if facts[:osfamily] == 'Debian'
              it do
                is_expected.to contain_file('/etc/default/bamboo')
                  .with_content(%r{^TEST_VAR=foo$})
                  .that_notifies('Service[bamboo]')
              end
            end
          end
        end
      end
    end
  end
end
