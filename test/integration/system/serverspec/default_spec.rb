require 'spec_helper'

describe 'cop_newrelic::system' do
  describe file('/etc/newrelic/nrsysmond.cfg') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
    it { should contain 'license_key=ba3b0fb4b29c4919bfec0fb2f255dfd9e4bdd8f5' }
  end

  describe package('newrelic-sysmond') do
    it { should be_installed }
  end

  describe command('nrsysmond -v') do
    its(:stdout) { should match /daemon version 2.3.*/ }
  end

  describe user('newrelic') do
    it { should exist }
  end

  describe group('newrelic') do
    it { should exist }
  end

  it 'the newrelic service is enabled' do
    expect(service('newrelic-sysmond')).to be_enabled
  end

  it 'the newrelic service is running' do
    expect(service('newrelic-sysmond')).to be_running
  end
end
