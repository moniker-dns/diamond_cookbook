# Install the PowerDNS collector config

include_recipe 'diamond::default'

collector_config "PowerDNSCollector" do
  use_sudo  node[:diamond][:collectors][:PowerDNSCollector][:use_sudo]
end
