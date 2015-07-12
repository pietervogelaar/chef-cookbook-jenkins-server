# Install plugins
node['jenkins-server']['plugins'].each do |plugin, options|
  if options
    jenkins_plugin plugin do
      version options['version']
    end
  end
end