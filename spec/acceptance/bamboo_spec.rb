require 'spec_helper_acceptance'

download_url = ENV['download_url'] if ENV['download_url']
if ENV['download_url']
  download_url = ENV['download_url']
else
  download_url = 'undef'
end
if download_url != 'undef'
  java_url = download_url
else
  download_url = 'http://www.atlassian.com/software/bamboo/downloads/binary'
  java_url = "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/"
end

describe 'bamboo class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      file { '/opt/java': ensure => directory } ->
      staging::file { 'jdk-8u73-linux-x64.tar.gz':
        source => '#{java_url}/jdk-8u73-linux-x64.tar.gz',
        timeout => '180',
        curl_option => '--header "Cookie: oraclelicense=accept-securebackup-cookie"',
      } ->
      staging::extract { 'jdk-8u73-linux-x64.tar.gz':
        target => '/opt/java',
        creates => '/opt/java/bin/java',
        strip => '1',
      } ->
      class { 'bamboo':
        download_url  => '#{download_url}',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      shell 'cat /opt/bamboo/atlassian-bamboo-5.10.2/logs/catalina.out'
      sleep 30
      shell 'wget -q --tries=20 --retry-connrefused --read-timeout=10 localhost:8085'
      apply_manifest(pp, :catch_changes => true)
    end

    describe process('java') do
      it { is_expected.to be_running }
    end

    describe port(8085) do
      it { is_expected.to be_listening }
    end

    describe service('bamboo') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe user('bamboo') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_group 'bamboo' }
    end

    describe command('curl -L http://localhost:8085') do
      its(:stdout) { is_expected.to match(/version 5.10.2/) }
    end
  end
end
