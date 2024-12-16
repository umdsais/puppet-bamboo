require 'spec_helper'

describe 'bamboo' do
  context 'unsupported operating systems' do
    let(:facts) { { osfamily: 'Windows' } }

    it { expect { catalogue }.to raise_error(Puppet::Error, %r{not supported}) }
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'default parameters' do
          let(:params) { { version: BAMBOO_VERSION } }

          it { is_expected.to contain_class('bamboo') }
          it { is_expected.to contain_class('bamboo::params') }
          it { is_expected.to contain_class('bamboo::install').that_comes_before('Class[bamboo::facts]') }
          it { is_expected.to contain_class('bamboo::facts').that_comes_before('Class[bamboo::configure]') }
          it { is_expected.to contain_class('bamboo::configure').that_notifies('Class[bamboo::service]') }
        end

        context 'invalid parameters' do
          context 'version' do
            let(:params) { { version: 'invalid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{parameter 'version' expects a match}) }
          end

          context 'extension' do
            let(:params) { { extension: '.exe' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{parameter 'extension' expects a match}) }
          end

          context 'manage_installdir' do
            let(:params) { { manage_installdir: 'true' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'installdir' do
            let(:params) { { installdir: 'notabsolute' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Pattern.*, got 'notabsolute'}) }
          end

          context 'manage_appdir' do
            let(:params) { { manage_appdir: 'true' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'appdir' do
            let(:params) { { appdir: 'notabsolute' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'notabsolute'}) }
          end

          context 'homedir' do
            let(:params) { { homedir: 'aint_valid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Pattern.*, got 'aint_valid'}) }
          end

          context 'context_path' do
            let(:params) { { context_path: ['invalid'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{parameter 'context_path' expects a String}) }
          end

          context 'tomcat_port' do
            let(:params) { { tomcat_port: 'none' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Stdlib::Port = Integer.*, got 'none'}) }
          end

          context 'max_threads' do
            let(:params) { { max_threads: 'invalid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'invalid'}) }
          end

          context 'min_spare_threads' do
            let(:params) { { min_spare_threads: 'invalid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'invalid'}) }
          end

          context 'connection_timeout' do
            let(:params) { { connection_timeout: 'invalid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'invalid'}) }
          end

          context 'accept_count' do
            let(:params) { { accept_count: 'valid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'valid'}) }
          end

          context 'proxy' do
            let(:params) { { proxy: 'this is wrong' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a value of type Undef or Hash, got String}) }
          end

          context 'manage_user' do
            let(:params) { { manage_user: 'jdoe' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'manage_group' do
            let(:params) { { manage_group: 'sdoe' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'user' do
            let(:params) { { user: 'not$valid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'not\$valid'}) }
          end

          context 'group' do
            let(:params) { { group: 'not%this one' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'not%this one'}) }
          end

          context 'uid' do
            let(:params) { { uid: ['denver'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Tuple}) }
          end

          context 'gid' do
            let(:params) { { gid: ['colorado'] } }

            it { expect { catalogue }.to raise_error(Puppet::Error, %r{got Tuple}) }
          end

          context 'password' do
            let(:params) { { password: ['yeah, should be string'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{parameter 'password' expects a String value}) }
          end

          context 'shell' do
            let(:params) { { shell: 'nologin' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'nologin'}) }
          end

          context 'java_home' do
            let(:params) { { java_home: 'idunno' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'idunno'}) }
          end

          context 'jvm_xms' do
            let(:params) { { jvm_xms: 'invalid' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'invalid'}) }
          end

          context 'jvm_xmx' do
            let(:params) { { jvm_xmx: 'lazy' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'lazy'}) }
          end

          context 'jvm_opts' do
            let(:params) { { jvm_opts: ['should be a string'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Tuple}) }
          end

          context 'jvm_optional' do
            let(:params) { { jvm_optional: ['also should be string'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Tuple}) }
          end

          context 'download_url' do
            let(:params) { { download_url: '//path/to/my/bsod' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got '//path/to/my/bsod'}) }
          end

          context 'manage_service' do
            let(:params) { { manage_service: 'sure' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'service_ensure' do
            let(:params) { { service_ensure: 'definitely' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Enum\['running', 'stopped'\], got 'definitely'}) }
          end

          context 'service_enable' do
            let(:params) { { service_enable: 'yes' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'service_file' do
            let(:params) { { service_file: 'init.d/bamboo' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Pattern.*, got 'init.d/bamboo'}) }
          end

          context 'service_template' do
            let(:params) { { service_template: 'foo.erb' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Pattern.*, got 'foo.erb'}) }
          end

          context 'shutdown_wait' do
            let(:params) { { shutdown_wait: 'false' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{Pattern.*Integer\], got 'false'}) }
          end

          context 'initconfig_manage' do
            let(:params) { { initconfig_manage: 'true' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean value, got String}) }
          end

          context 'initconfig_path' do
            let(:params) { { initconfig_path: 'notabsolute' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'notabsolute'}) }
          end

          context 'initconfig_content' do
            let(:params) { { initconfig_content: {} } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a value of type Undef or String, got Hash}) }
          end

          context 'facts_ensure' do
            let(:params) { { facts_ensure: 'nothanks' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'nothanks'}) }
          end

          context 'facter_dir' do
            let(:params) { { facter_dir: 'notabsolute' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'notabsolute'}) }
          end

          context 'create_facter_dir' do
            let(:params) { { create_facter_dir: 'true' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a Boolean}) }
          end

          context 'stop_command' do
            let(:params) { { stop_command: ['rm -rf /sjw'] } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a String}) }
          end

          context 'umask' do
            let(:params) { { umask: 'something' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'something'}) }
          end

          context 'umask as an integer' do
            let(:params) { { umask: 222 } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Integer}) }
          end

          context 'proxy_server' do
            let(:params) { { proxy_server: true } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Boolean}) }
          end

          context 'proxy_type' do
            let(:params) { { proxy_type: true } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Boolean}) }
          end

          context 'checksum' do
            let(:params) { { checksum: true } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got Boolean}) }
          end

          context 'checksum_type' do
            let(:params) { { checksum_type: 'piggy' } }

            it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{got 'piggy'}) }
          end
        end
      end
    end
  end
end
