jenkins_script 'configure settings' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def instance = Jenkins.getInstance()

    instance.setNumExecutors(#{node['jenkins-server']['settings']['executors']})
    instance.setSlaveAgentPort(#{node['jenkins-server']['settings']['slave_agent_port']})
    instance.save()

    def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

    // Admin address
    jenkinsLocationConfiguration.setAdminAddress('#{node['jenkins-server']['settings']['system_email']}')
    jenkinsLocationConfiguration.save()

    // Mailer
    def descriptor = instance.getDescriptor('hudson.tasks.Mailer')

    descriptor.setSmtpHost('#{node['jenkins-server']['settings']['mailer']['smtp_host']}')
    descriptor.setSmtpAuth('#{node['jenkins-server']['settings']['mailer']['username']}', '#{node['jenkins-server']['settings']['mailer']['password']}')
    descriptor.setUseSsl(#{node['jenkins-server']['settings']['mailer']['use_ssl']})
    descriptor.setSmtpPort('#{node['jenkins-server']['settings']['mailer']['smtp_port']}')
    descriptor.setReplyToAddress('#{node['jenkins-server']['settings']['mailer']['reply_to_address']}')
    descriptor.setCharset('#{node['jenkins-server']['settings']['mailer']['charset']}')

    descriptor.save()
  EOH
end