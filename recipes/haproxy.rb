# Install the haproxy collector config

include_recipe 'diamond::default'

collector_config "HAProxyCollector" do
  url   node[:diamond][:collectors][:HAProxyCollector][:url]
end
