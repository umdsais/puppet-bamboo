require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "bamboo class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('bamboo') }

          it { is_expected.to contain_class('bamboo::params') }
          it { is_expected.to contain_class('bamboo::install').that_comes_before('bamboo::config') }
          it { is_expected.to contain_class('bamboo::config') }
          it { is_expected.to contain_class('bamboo::service').that_subscribes_to('bamboo::config') }

          it { is_expected.to contain_user('bamboo').with(
            :ensure => 'present',
            :comment => 'Bamboo service account',
            :home => '/var/bamboo',
            :managehome => true,
            :system => true
          ) }
          it { is_expected.to contain_file('/opt/bamboo').with(
            :ensure => 'directory',
            :owner => 'bamboo',
            :recurse => true,
          ).that_requires('User[bamboo]') }
          it { is_expected.to contain_staging__deploy('atlassian-bamboo-5.8.1.tar.gz').with(
            :target => '/opt/bamboo',
            :source => 'https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.8.1.tar.gz',
            :user => 'bamboo'
          ).that_requires('File[/opt/bamboo]') }
          it { is_expected.to contain_file('/opt/bamboo/current').with(
            :ensure => 'link',
            :target => '/opt/bamboo/atlassian-bamboo-5.8.1'
          ).that_requires('Staging::Deploy[atlassian-bamboo-5.8.1.tar.gz]') }
          it { is_expected.to contain_file('/var/log/bamboo').with(
            :ensure => 'link',
            :target => '/opt/bamboo/current/logs'
          ).that_requires('File[/opt/bamboo/current]') }

          it { is_expected.to contain_file('/opt/bamboo/current/conf/server.xml').with(
            :ensure => 'file',
            :owner => 'bamboo'
          ) }
          it { is_expected.to contain_file('/opt/bamboo/current/bin/setenv.sh').with(
            :ensure => 'file',
            :mode => '0755',
            :owner => 'bamboo'
          ) }
          it { is_expected.to contain_file('/etc/init.d/bamboo').with(
            :ensure => 'file',
            :mode => '0755'
          ) }

          it { is_expected.to contain_service('bamboo') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'bamboo class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('bamboo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
