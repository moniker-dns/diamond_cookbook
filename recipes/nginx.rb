# Install the nginx collector config

include_recipe 'diamond::default'

template "#{node['nginx']['dir']}/sites-available/status" do
  source   "nginx_status_site.erb"
  owner    "root"
  group    "root"
  mode     "0644"
  notifies :reload, 'service[nginx]'
end

nginx_site 'status' do
  enable true
end

collector_config "NginxCollector" do
  req_host  node[:diamond][:collectors][:NginxCollector][:req_host]
  req_port  node[:diamond][:collectors][:NginxCollector][:req_port]
  req_path  node[:diamond][:collectors][:NginxCollector][:req_path]
end

