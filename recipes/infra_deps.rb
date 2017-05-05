#
# Cookbook Name:: cop_newrelic
# Recipe:: package
#

cache = Chef::Config[:file_cache_path]

remote_file 'download newrelic-infra gpg' do
    path   "#{cache}/newrelic-infra.gpg"
    source 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'
    owner  'root'
    group  'root'
    mode   0644
    action :create
end

case node['platform_family']
when 'debian'
    # NOTE: support for https in apt repos
    package 'apt-transport-https' do
        action :install
    end

    file 'install newrelic-infra repo' do
        path     '/etc/apt/sources.list.d/newrelic-infra.list'
        content  "deb [arch=amd64] http://download.newrelic.com/infrastructure_agent/linux/apt #{node['lsb']['codename']} main"
        user     'root'
        group    'root'
        mode     0644
        action   :create
        notifies :run, 'execute[trust newrelic-infra gpg]', :immediately
        notifies :run, 'execute[update apt]', :immediately
    end

    execute 'trust newrelic-infra gpg' do
        action  :nothing
        command "cat #{cache}/newrelic-infra.gpg | apt-key add -"
        not_if  'apt-key list | grep 8ECCE87C'
    end

    execute 'update apt' do                                                                                                                                                                                         command 'apt-get update'
        action  :nothing
    end
when 'rhel'
    file 'install newrelic-infra repo' do
        path     '/etc/yum.repos.d/newrelic-infra.repo'
        # NOTE: node['platform_version'][0] is the first char of the OS version
        content  "[newrelic-infra]
name=New Relic Infrastructure
baseurl=https://download.newrelic.com/infrastructure_agent/linux/yum/el/#{node['platform_version'][0]}/$basearch
enabled=1
gpgcheck=1"
        user     'root'
        group    'root'
        mode     0644
        action   :create
        notifies :run, 'execute[trust newrelic-infra gpg]', :immediately
    end

    execute 'trust newrelic-infra gpg' do
        command "rpm --import #{cache}/newrelic-infra.gpg"
        not_if  'rpm -qa gpg-pubkey* | grep 8ECCE87C'
        action  :nothing
    end
end
