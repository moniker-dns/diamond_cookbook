default[:diamond][:default_poll_interval] = 300
default[:diamond][:default_path_prefix] = 'servers'
default[:diamond][:graphite_search] = "role:graphite AND chef_environment:#{node.chef_environment}"

if node[:repositories].nil? && node[:repositories]['diamond'].nil? && node[:repositories]['diamond'][:version].nil?
  case node[:platform]
    when "ubuntu","debian"
      default[:diamond][:version] = '3.3.0'
    else
      default[:diamond][:version] = '3.3.0-0'
  end
else
  default[:diamond][:version] = node[:repositories]['diamond'][:version]
end
