#
# Cookbook Name:: cop_newrelic
# Recipe:: infrastructure
#

include_recipe 'cop_newrelic::infra_deps'

if node['newrelic']['infrastructure']['install'] == true
    package 'newrelic-infra' do
        action  :upgrade
        version node['newrelic']['infrastructure']['version'] unless node['newrelic']['infrastructure']['version'].nil?
    end

    template '/etc/newrelic-infra.yml' do
        source   'newrelic-infra.yml.erb'
        owner    'root'
        group    'root'
        mode     0644
        notifies :restart, 'service[newrelic-infra]', :delayed
    end

    service 'newrelic-infra' do
        action [:enable, :start]
    end
end
