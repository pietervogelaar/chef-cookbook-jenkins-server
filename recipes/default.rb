if node['jenkins-server']['java']['install']
  include_recipe 'java'
end

include_recipe 'jenkins::master'
include_recipe 'jenkins-server::security'
include_recipe 'jenkins-server::plugins'