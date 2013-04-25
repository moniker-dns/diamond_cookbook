# install diamond and enable basic collectors

graphite_pool = search("node", "role:graphite AND chef_environment:#{node.chef_environment}") || []
graphite_pool << node if node.run_list.roles.include?('graphite')

# reduce the graphite_pool down to just the IPs, private if we are in the same AZ, public if they are in a remove AZ
graphite_pool.map! do |member|
  server_ip = begin
    if member.attribute?('meta_data')
      if node.attribute?('meta_data') && (member['meta_data']['region'] == node['meta_data']['region'])
        member['meta_data']['private_ipv4']
      else
        member['meta_data']['public_ipv4']
      end
    else
      member['ipaddress']
    end
  end
end

graphite_pool.uniq!

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
      action :install
      version node['diamond']['version']
    end

  when "centos", "redhat", "fedora", "amazon", "scientific"
    package "diamond" do
      action :install
      version node['diamond']['version']
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
