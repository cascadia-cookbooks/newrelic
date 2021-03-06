#
# Cookbook Name:: cop_newrelic
# Recipe:: application
#

include_recipe 'cop_newrelic::app_deps'

if node['newrelic']['php']['install'] == true
    package 'newrelic-php5' do
        action   :install
        notifies :run, 'execute[newrelic install]', :immediately
    end

    execute 'newrelic install' do
        command 'newrelic-install install'
        action  :nothing
        environment(
            'NR_INSTALL_SILENT' => '1'
        )
    end

    file '/etc/newrelic/newrelic.cfg.template' do
        action :delete
    end

    file '/etc/newrelic/newrelic.cfg' do
        action   :delete
        notifies :run, 'execute[kill any running daemons linking old config]', :immediately
    end

    execute 'kill any running daemons linking old config' do
        command 'killall newrelic-daemon'
        action  :nothing
    end

    template "#{node['php']['sapi']['fpm']['module_ini_path']}/newrelic.ini" do
        source   'newrelic.ini.erb'
        owner    'root'
        group    'root'
        mode     0644
        notifies :restart, "service[#{node['php']['sapi']['fpm']['fpm_service_name']}]", :delayed
    end

    service 'newrelic-daemon' do
        action :disable
    end

    service node['php']['sapi']['fpm']['fpm_service_name'] do
        action :nothing
    end
end
