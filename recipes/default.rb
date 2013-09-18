# install diamond and enable basic collectors

node.set[:graphite_pool] =  search_helper_best_ip(node[:diamond][:graphite_search], node[:diamond][:graphite_server], false) do |ip, other_node|
  ip
end

# add ourselves if this is the graphite node, but only if we have an IP address
node.set[:graphite_pool] << node[:ipaddress] if node.run_list.roles.include?('graphite') && !node[:ipaddress].nil?

Chef::Log.info node[:graphite_pool]

# remove any duplicates
node.set[:graphite_pool] = node[:graphite_pool].uniq
graphite_pool = node[:graphite_pool]

if graphite_pool.length == 0
  Chef::Log.warn "No Graphite servers found. Bailing"
  return
elsif graphite_pool.length > 1
  Chef::Log.warn "Too many Graphite servers found. Bailing"
  return
end

case node[:platform]
  when "debian", "ubuntu"
    package "python-pysnmp4" do
      action :install
    end

    package "diamond" do
      action :upgrade
    end

  when "centos", "redhat", "fedora", "amazon", "scientific"
    package "diamond" do
      action :upgrade
    end
end

service "diamond" do
  action [ :enable, :start ]
end

template "/etc/diamond/diamond.conf" do
  source "diamond.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:graphite_pool => graphite_pool.uniq)
  notifies :restart, resources(:service => "diamond")
end

cookbook_file "/etc/sudoers.d/91-diamond" do
  source "sudoers"
  owner "root"
  group "root"
  mode "0440"
  notifies :restart, resources(:service => "diamond")
end

#install basic collector configs
include_recipe 'diamond::diskusage'
include_recipe 'diamond::diskspace'
include_recipe 'diamond::vmstat'
include_recipe 'diamond::memory'
include_recipe 'diamond::network'
include_recipe 'diamond::tcp'
include_recipe 'diamond::loadavg'
include_recipe 'diamond::cpu'
include_recipe 'diamond::ntpd'
