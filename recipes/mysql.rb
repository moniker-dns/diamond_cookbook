# Install the mysql collector config

include_recipe 'diamond::default'

collector_config "MySQLCollector" do
  path    node[:diamond][:collectors][:MySQLCollector][:path]
  host    node[:diamond][:collectors][:MySQLCollector][:host]
  port    node[:diamond][:collectors][:MySQLCollector][:port]
  db      node[:diamond][:collectors][:MySQLCollector][:db]
  user    node[:diamond][:collectors][:MySQLCollector][:username]
  passwd  node[:diamond][:collectors][:MySQLCollector][:password]
end

