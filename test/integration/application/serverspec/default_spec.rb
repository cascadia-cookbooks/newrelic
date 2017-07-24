require 'spec_helper'

describe 'cop_newrelic::application' do
  describe file('/etc/newrelic/newrelic.cfg') do
    it { should_not exist }
  end

  describe file('/tmp/newrelic.ini') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
    it { should contain 'newrelic.enabled=true' }
    it { should contain 'newrelic.license = "ba3b0fb4b29c4919bfec0fb2f255dfd9e4bdd8f5"' }
    it { should contain 'newrelic.appname = "testing.com"' }
  end

  describe package('newrelic-php5') do
    it { should be_installed }
  end

  describe command('newrelic-daemon -v') do
    its(:stdout) { should match /daemon version 7.*/ }
  end

  it 'the newrelic daemon is enabled' do
    expect(service('newrelic-daemon')).to be_enabled
  end

  it 'the newrelic daemon is running' do
    expect(service('newrelic-daemon')).to be_running
  end
end
