default[:diamond][:default_poll_interval] = 300
default[:diamond][:default_path_prefix] = 'servers'

case node[:platform]
  when "ubuntu","debian"
    default[:diamond][:version] = '3.3.0'
  else
    default[:diamond][:version] = '3.3.0-0'
end

