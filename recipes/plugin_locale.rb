jenkins_script 'configure plugin locale' do
  command <<-EOH.gsub(/^ {4}/, '')
    def pluginWrapper = jenkins.model.Jenkins.instance.getPluginManager().getPlugin('locale')
    def plugin = pluginWrapper.getPlugin()

    plugin.setSystemLocale('#{node['jenkins-server']['plugins']['locale']['system_locale']}')
    plugin.ignoreAcceptLanguage = #{node['jenkins-server']['plugins']['locale']['ignore_accept_language'] ? 'true' : 'false'}
  EOH
end