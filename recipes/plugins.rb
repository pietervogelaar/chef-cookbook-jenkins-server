# Install plugins
Chef::Log.debug '[JENKINS-SERVER] Installing plugins'

node['jenkins-server']['plugins'].each do |plugin, options|
  if options
    jenkins_plugin plugin do
      version options['version']
    end
  end
end

# Restart jenkins for the first time and set a flag
unless node.attribute?('jenkins_restarted_once')
  Chef::Log.debug '[JENKINS-SERVER] First time Jenkins restart'

  service 'jenkins' do
    action :restart
  end

  node.set['jenkins_restarted_once'] = true
  node.save
end

# Configure plugins
Chef::Log.debug '[JENKINS-SERVER] Configure jenkins plugins'

node['jenkins-server']['plugins'].each do |plugin, options|
  if options && options['configure']
    cookbook = options.key?('cookbook') && options['cookbook'] != '' ? options['cookbook'] : cookbook_name
    recipe = options.key?('recipe') && options['recipe'] != '' ? options['recipe'] : "plugin_#{plugin}"

    include_recipe "#{cookbook}::#{recipe}"
  end
end