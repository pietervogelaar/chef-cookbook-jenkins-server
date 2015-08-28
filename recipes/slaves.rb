# Get the slaves data bag
slaves = data_bag(node['jenkins-server']['slaves']['data_bag'])

# Add slaves from data bag items
slaves.each do |data_bag_item_id|
  slave = data_bag_item(node['jenkins-server']['slaves']['data_bag'], data_bag_item_id)

  if slave.key?('type') && slave['type'] == 'ssh'
    jenkins_ssh_slave slave['name'] do
      host        slave['host']
      credentials slave['credentials']

      if slave.key?('description') then description slave['description'] end
      if slave.key?('remote_fs') then remote_fs slave['remote_fs'] end
      if slave.key?('executors') then executors slave['executors'] end
      if slave.key?('usage_mode') then usage_mode slave['usage_mode'] end
      if slave.key?('labels') then labels slave['labels'] end
      if slave.key?('availability') then availability slave['availability'] end
      if slave.key?('in_demand_delay') then in_demand_delay slave['in_demand_delay'] end
      if slave.key?('idle_delay') then idle_delay slave['idle_delay'] end
      if slave.key?('environment') then environment slave['environment'] end
      if slave.key?('offline_reason') then offline_reason slave['offline_reason'] end
      if slave.key?('jvm_options') then jvm_options slave['jvm_options'] end
      if slave.key?('java_path') then java_path slave['java_path'] end
    end
  end
end
