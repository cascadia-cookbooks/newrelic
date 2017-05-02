#
# Cookbook Name:: cop_newrelic
# Recipe:: package
#

cache = Chef::Config[:file_cache_path]

remote_file 'download newrelic gpg' do
    path   "#{cache}/newrelic.gpg"
    source 'https://download.newrelic.com/548C16BF.gpg'
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

    remote_file 'install newrelic apt source' do
        path     '/etc/apt/sources.list.d/newrelic.list'
        source   'https://download.newrelic.com/debian/newrelic.list'
        owner    'root'
        group    'root'
        mode     0644
        action   :create
        notifies :run, 'execute[trust newrelic gpg]', :immediately
        notifies :run, 'execute[update apt]', :immediately
    end

    execute 'trust newrelic gpg' do
        action  :nothing
        command "cat #{cache}/newrelic.gpg | apt-key add -"
        not_if  'apt-key list | grep 548C16BF'
    end

    execute 'update apt' do                                                                                                                                                                                         command 'apt-get update'
        action  :nothing
    end
when 'rhel'
    file 'install newrelic repo' do
        path     '/etc/yum.repos.d/newrelic.repo'
        content  "[newrelic]
name=New Relic packages for Enterprise Linux 5 - $basearch
baseurl=https://yum.newrelic.com/pub/newrelic/el5/$basearch
enabled=1
gpgcheck=1"
        user     'root'
        group    'root'
        mode     0644
        action   :create
        notifies :run, 'execute[trust newrelic gpg]', :immediately
    end

    execute 'trust newrelic gpg' do
        command "rpm --import #{cache}/newrelic.gpg"
        not_if  'rpm -qa gpg-pubkey* | grep 548c16bf-4c29a642'
        action  :nothing
    end
end
