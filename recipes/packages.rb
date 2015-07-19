if node['jenkins-server']['packages']['java']['install']
  include_recipe 'java'
end

if node['jenkins-server']['packages']['ant']['install']
  include_recipe 'ant'
end

if node['jenkins-server']['packages']['git']['install']
  include_recipe 'git'
end
