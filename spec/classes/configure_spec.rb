require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'bamboo::configure class without any parameters' do
          let(:params) { {} }

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_owner('bamboo')
              .with_group('bamboo')
              .with_content(%r{^BAMBOO_HOME="\/var\/local\/bamboo"$})
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_content(%r{^: \$\{JVM_SUPPORT_RECOMMENDED_ARGS:=""\}$})
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_content(%r{^: \$\{JVM_MINIMUM_MEMORY:=256m\}$})
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_content(%r{^: \$\{JVM_MAXIMUM_MEMORY:=1024m\}$})
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_content(%r{^CATALINA_OPTS=" -Xms\$\{JVM_MINIMUM_MEMORY\}.*"})
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties")
              .with_content(%r{^bamboo\.home=\/var\/local\/bamboo$})
          end

          it do
            is_expected.to contain_augeas("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/conf/server.xml").with(
              'changes' => [
                "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path ''",
                "set Server/Service/Connector/#attribute/maxThreads '150'",
                "set Server/Service/Connector/#attribute/minSpareThreads '25'",
                "set Server/Service/Connector/#attribute/connectionTimeout '20000'",
                "set Server/Service/Connector/#attribute/port '8085'",
                "set Server/Service/Connector/#attribute/acceptCount '100'",
              ],
            )
          end
        end
        context 'bamboo::configure class with custom catalina_opts' do
          let(:params) do
            {
              jvm_opts: '-Foo -Bar',
            }
          end

          it do
            is_expected.to contain_file("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/bin/setenv.sh")
              .with_content(%r{^CATALINA_OPTS="-Foo -Bar -Xms\$\{JVM_MINIMUM_MEMORY\}.*"})
          end
        end
        context 'bamboo::configure class with custom tomcat settings' do
          let(:params) do
            {
              max_threads: '256',
              min_spare_threads: '100',
              connection_timeout: '30000',
              tomcat_port: '9090',
              accept_count: '200',
              proxy: {
                'scheme'    => 'https',
                'proxyName' => 'bamboo.example.com',
                'proxyPort' => '443',
              },
            }
          end

          it do
            is_expected.to contain_augeas("/usr/local/bamboo/atlassian-bamboo-#{BAMBOO_VERSION}/conf/server.xml").with(
              'changes' => [
                "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path ''",
                "set Server/Service/Connector/#attribute/maxThreads '256'",
                "set Server/Service/Connector/#attribute/minSpareThreads '100'",
                "set Server/Service/Connector/#attribute/connectionTimeout '30000'",
                "set Server/Service/Connector/#attribute/port '9090'",
                "set Server/Service/Connector/#attribute/acceptCount '200'",
                "set Server/Service/Connector[#attribute/protocol = \"HTTP/1.1\"]/#attribute/scheme 'https'",
                "set Server/Service/Connector[#attribute/protocol = \"HTTP/1.1\"]/#attribute/proxyName 'bamboo.example.com'",
                "set Server/Service/Connector[#attribute/protocol = \"HTTP/1.1\"]/#attribute/proxyPort '443'",
              ],
            )
          end
        end
      end
    end
  end
end
