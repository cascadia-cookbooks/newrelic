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

    template '/etc/newrelic/newrelic.cfg' do
        source   'newrelic.cfg.erb'
        owner    'root'
        group    'root'
        mode     0644
        notifies :restart, 'service[newrelic-daemon]', :delayed
    end

    if node['php']['sapi']['fpm']['module_ini_path']
        template "#{node['php']['sapi']['fpm']['module_ini_path']}/newrelic.ini" do
            source   'newrelic.ini.erb'
            owner    'root'
            group    'root'
            mode     0644
            notifies :restart, 'service[newrelic-daemon]', :delayed
        end
    end

    service 'newrelic-daemon' do
        action [:enable, :start]
    end
end
