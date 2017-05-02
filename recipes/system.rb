#
# Cookbook Name:: cop_newrelic
# Recipe:: system
#

include_recipe 'cop_newrelic::package'

if node['newrelic']['system']['install'] == true
    package 'newrelic-sysmond' do
        action :install
    end

    template '/etc/newrelic/nrsysmond.cfg' do
        source   'nrsysmond.cfg.erb'
        owner    'root'
        group    'root'
        mode     0644
        notifies :restart, 'service[newrelic-sysmond]', :delayed
    end

    service 'newrelic-sysmond' do
        action [:enable, :start]
    end
end
