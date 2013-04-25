# Install the RabbitMQ collector config

include_recipe 'diamond::default'

package "python-pyrabbit"

collector_config "RabbitMQCollector" do
  user      node[:diamond][:collectors][:RabbitMQCollector][:user]
  password  node[:diamond][:collectors][:RabbitMQCollector][:password]
end

