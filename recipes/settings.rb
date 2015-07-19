jenkins_script 'configure settings' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def instance = Jenkins.getInstance()

    instance.setNumExecutors(#{node['jenkins-server']['settings']['executors']})
    instance.setSlaveAgentPort(#{node['jenkins-server']['settings']['slave_agent_port']})
    instance.save()

    def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

    jenkinsLocationConfiguration.setAdminAddress('#{node['jenkins-server']['settings']['system_email']}')
    jenkinsLocationConfiguration.save()
  EOH
end