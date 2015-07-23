include_recipe 'nginx'

template "#{node['nginx']['dir']}/sites-available/jenkins.conf" do
  cookbook node['jenkins-server']['nginx']['template_cookbook']
  source node['jenkins-server']['nginx']['template_source']
  owner  node['nginx']['user']
  group  node['nginx']['group']
  mode   '0644'
  notifies :reload, "service[#{node['nginx']['package_name']}]", :delayed
end

nginx_site 'jenkins.conf' do
  enable true
end