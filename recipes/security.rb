if node['dev_mode']
  jenkins_user = {
      'password' => node['jenkins-server']['dev_mode']['security']['password'],
      'private_key' => node['jenkins-server']['dev_mode']['security']['private_key'],
      'public_key' => node['jenkins-server']['dev_mode']['security']['public_key']
  }
else
  jenkins_user = chef_vault_item(
      node['jenkins-server']['security']['chef-vault']['data_bag'],
      node['jenkins-server']['security']['chef-vault']['data_bag_item']
  )
end

# Set the private key in the run state only if security was enabled in a previous chef run
if node.attribute?('jenkins_security_enabled')
  Chef::Log.debug '[JENKINS] Security is enabled in a previous run'

  node.run_state[:jenkins_private_key] = jenkins_user['private_key']
end

# Add the admin user, but only the first run
jenkins_user node['jenkins-server']['admin']['username'] do
  password jenkins_user['password']
  public_keys [jenkins_user['public_key']]
  not_if { node.attribute?('jenkins_security_enabled') }
  notifies :execute, 'jenkins_script[configure permissions]', :immediately
end

# By default Jenkins allows everybody. Configure "Global Matrix Authorization" and
# give the admin user the "administrator" permission
jenkins_script 'configure permissions' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*

    def instance = Jenkins.getInstance()

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new GlobalMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, "#{node['jenkins-server']['admin']['username']}")
    instance.setAuthorizationStrategy(strategy)

    instance.save()
  EOH
  notifies :create, 'ruby_block[set jenkins_security_enabled flag]', :immediately
  action :nothing
end

# Set the jenkins_security_enabled flag and set run_state to use the configured private key
ruby_block 'set jenkins_security_enabled flag' do
  block do
    node.run_state[:jenkins_private_key] = jenkins_user['private_key']
    node.set['jenkins_security_enabled'] = true
    node.save
  end
  action :nothing
end