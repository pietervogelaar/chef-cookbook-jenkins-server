default['jenkins']['master']['version'] = '1.619-1.1'
default['jenkins']['master']['host'] = 'localhost'
default['jenkins']['master']['port'] = 8084
default['jenkins']['master']['endpoint'] = "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}"
default['jenkins']['master']['jvm_options'] = '-Xms256m -Xmx256m'
default['jenkins']['master']['listen_address'] = '127.0.0.1'