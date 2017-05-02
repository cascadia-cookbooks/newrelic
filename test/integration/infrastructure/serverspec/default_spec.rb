require 'spec_helper'

describe 'cop_newrelic::infrastructure' do
  describe file('/etc/newrelic-infra.yml') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
    it { should contain 'license_key: ba3b0fb4b29c4919bfec0fb2f255dfd9e4bdd8f5' }
  end

  describe package('newrelic-infra') do
    it { should be_installed }
  end

  describe command('newrelic-infra -version') do
    its(:stdout) { should match /Agent version: 1.*/ }
  end

  it 'the newrelic infra service is enabled' do
    expect(service('newrelic-infra')).to be_enabled
  end

  it 'the newrelic infra service is running' do
    expect(service('newrelic-infra')).to be_running
  end
end
