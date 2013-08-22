default[:diamond][:default_poll_interval] = 300
default[:diamond][:default_path_prefix] = 'servers'
default[:diamond][:graphite_search] = "role:graphite AND chef_environment:#{node.chef_environment}"
