require 'spec_helper'

describe 'docker::service' do
  let(:test_params) { {
    :ensure       => 'present',
    :configdir    => '/test/boxen/config/docker',
    :datadir      => '/test/boxen/data/docker',
    :enable       => true,
    :logdir       => '/test/boxen/log/docker',
    :machinename  => 'test',
    :service      => 'dev.docker',
    :user         => 'testuser',
    :vboxdir      => '/test/boxen/virtualbox/bin'
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }

  context 'ensure => present' do
    it do
      should contain_service('dev.docker').with({
        :ensure => :running,
        :enable => true,
      })
    end
  end

  context 'ensure => absent' do
    let(:params) { test_params.merge(:ensure => 'absent') }

    it do
      should contain_service('dev.docker').with_ensure('stopped')
    end
  end

  context 'enable => false' do
    let(:params) { test_params.merge(:enable => false) }

    it do
      should contain_service('dev.docker').with_enable(false)
    end
  end

  describe 'osfamily => Darwin' do
    context 'ensure => present' do
      it do
        should contain_exec('docker-machine create').with({
          :command      => '/test/boxen/homebrew/bin/docker-machine create --driver=virtualbox test',
          :environment  => [
            'DOCKER_CONFIG=/test/boxen/config/docker',
            'MACHINE_STORAGE_PATH=/test/boxen/data/docker',
          ],
          :path         => %r{/test/boxen/virtualbox/bin},
          :user         => 'testuser',
          :unless       => '/test/boxen/homebrew/bin/docker-machine status test',
        })
        should contain_file('/Library/LaunchDaemons/dev.docker.plist').with_ensure(:present)
      end
    end

    context 'ensure => absent' do
      let(:params) { test_params.merge(:ensure => 'absent') }

      it do
        should contain_exec('docker-machine create').with({
          :command      => '/test/boxen/homebrew/bin/docker-machine rm test',
          :environment  => [
            'DOCKER_CONFIG=/test/boxen/config/docker',
            'MACHINE_STORAGE_PATH=/test/boxen/data/docker',
          ],
          :path         => %r{/test/boxen/virtualbox/bin},
          :user         => 'testuser',
          :unless       => nil,
        })
        should contain_file('/Library/LaunchDaemons/dev.docker.plist').with_ensure(:absent)
      end
    end
  end

  describe 'osfamily => Debian' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Debian') }

    it do
      should_not contain_exec('docker-machine create')
      should_not contain_file('/Library/LaunchDaemons/dev.docker.plist')
    end
  end
end
