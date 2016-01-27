jenkins_script 'configure plugin git' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def instance = Jenkins.getInstance()
    def descriptor = instance.getDescriptor('hudson.plugins.git.GitSCM')

    descriptor.setGlobalConfigName('#{node['jenkins-server']['plugins']['git']['global_config_name']}')
    descriptor.setGlobalConfigEmail('#{node['jenkins-server']['plugins']['git']['global_config_email']}')
    descriptor.setCreateAccountBasedOnEmail(#{node['jenkins-server']['plugins']['git']['create_account_based_on_email']})

    descriptor.save()
  EOH
end
