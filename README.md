# jenkins-server

This cookbook installs a complete Jenkins server with plugins and is highly configurable with attributes in this cookbook. It depends on the [Jenkins](https://supermarket.chef.io/cookbooks/jenkins) cookbook that is used as foundation. 

## Supported Platforms

- CentOS >= 6.6
- RHEL >= 6.6
- Ubuntu >= 12.04
- Debian >= 7.0

These platforms are officially supported, but it will probably work on other platforms to.

## Attributes

### General

* `default['jenkins-server']['admin']['username']` - Sets the username for the administrator user. Default "admin"
* `default['jenkins-server']['security']['chef-vault']['data_bag']` - Name of the data bag for jenkins users
* `default['jenkins-server']['security']['chef-vault']['data_bag_item']` - ID of the data bag to use as administrator user. This data bag must contain a password, private_key and public_key property

### Nginx

* `default['jenkins-server']['nginx']['install']` - Default `true`. Jenkins is proxied behind Nginx. If you want to disable this, set this attribute to `false` and `default['jenkins']['master']['listen_address']` to `0.0.0.0`. Jenkins will then be reachable on port 8080.
* `default['jenkins-server']['nginx']['server_name']` - Server name / hostname. Default "jenkins-server001.local"
* `default['jenkins-server']['nginx']['template_cookbook']` - The cookbook for the Nginx server template. Default "jenkins-server"
* `default['jenkins-server']['nginx']['template_source']` - The source for the Nginx server template. Default "nginx/jenkins.conf.erb"
* `default['jenkins-server']['nginx']['ssl']` - If a SSL connection must be used and forced. Default `false`
* `default['jenkins-server']['nginx']['ssl_cert_path']` - Path to the SSL certificate. Default `nil`
* `default['jenkins-server']['nginx']['ssl_key_path']` - Path to the SSL private key. Default `nil`

### Packages

* `default['jenkins-server']['java']['install']` - Installs Java with the [Java cookbook](https://supermarket.chef.io/cookbooks/java)
* `default['jenkins-server']['ant']['install']` - Installs Ant with the [Ant cookbook](https://supermarket.chef.io/cookbooks/ant)
* `default['jenkins-server']['git']['install']` - Installs Git with the [Git cookbook](https://supermarket.chef.io/cookbooks/git)
* `default['jenkins-server']['composer']['install']` - Installs Composer with the [Composer cookbook](https://supermarket.chef.io/cookbooks/composer). If `true`, the composer_vendors recipe will install the required [Jenkins-php.org](http://jenkins-php.org) vendors "squizlabs/php_codesniffer", "phploc/phploc", "pdepend/pdepend", "phpmd/phpmd", "sebastian/phpcpd" and "theseer/phpdox" 
* `default['jenkins-server']['composer']['template_cookbook']` - Template cookbook for composer.json. Default "jenkins-server" 
* `default['jenkins-server']['composer']['template_source']` - Template source for composer.json. Default "composer/composer.json.erb" 

### Settings

* `default['jenkins-server']['settings']['executors']` - Number of executors. Default the number of cores with a minimum of 2
* `default['jenkins-server']['settings']['slave_agent_port']` - Port number, or 0 to indicate random available TCP port (default) or -1 to disable this service
* `default['jenkins-server']['settings']['system_email']` - System email address
* `default['jenkins-server']['settings']['mailer']['smtp_host']` - Mailer SMTP host. Default "localhost"
* `default['jenkins-server']['settings']['mailer']['username']` - Mailer username. Default "mailer"
* `default['jenkins-server']['settings']['mailer']['password']` - Mailer password. Default "mailer"
* `default['jenkins-server']['settings']['mailer']['use_ssl']` - If the mailer must use SSL. Default `true`
* `default['jenkins-server']['settings']['mailer']['smtp_port']` - SMTP port. Default "25"
* `default['jenkins-server']['settings']['mailer']['reply_to_address']` - Reply to address. Default `node['jenkins-server']['settings']['system_email']`
* `default['jenkins-server']['settings']['mailer']['charset']` - Mail charset. Default "UTF-8"

### Plugins

These plugins are configured by default. See the attributes/default.rb for more details. Read for how to add a plugin the section "Adding plugins" further on.

- **General:** greenballs, locale, antisamy-markup-formatter, gravatar, ws-cleanup, ansicolor, build-monitor-plugin, git and ant
- **Version control:** bitbucket, bitbucket-pullrequest-builder
- **[Jenkins-php.org](http://jenkins-php.org):** checkstyle, cloverphp, crap4j, dry, htmlpublisher, jdepend, plot, pmd, violations, warnings and xunit

### Jobs

Jenkins jobs can be specified with attributes like:

    default['jenkins-server']['jobs']['myjob'] = {
      'cookbook' => 'mycookbook',
      'source' => 'jobs/myjob.xml.erb'
    }
    
By default the "php-template" job is installed from [Jenkins-php.org](http://jenkins-php.org). 

### Dev mode

If you are developing/testing your (wrapper) cookbook locally, chef-vault communication will be very difficult. If you set an attribute `default['dev_mode']` to `true` then these attributes
will be used to setup Jenkins security.

* `default['jenkins-server']['dev_mode']['security']['password']` - This password is used for the GUI login. Default "admin"
* `default['jenkins-server']['dev_mode']['security']['public_key']` - This public key (paired with the private key) is used for Jenkins CLI authentication
* `default['jenkins-server']['dev_mode']['security']['private_key']` - This private key (paired with the public key) is used for Jenkins CLI authentication

### Jenkins

Some attributes that overwrite the [Jenkins cookbook](https://supermarket.chef.io/cookbooks/jenkins) attributes:

* `default['jenkins']['master']['version']` - Jenkins version. Default 1.619-1.1
* `default['jenkins']['master']['jvm_options']` - JVM options. Default "-Xms256m -Xmx256m" which sets the memory usage to 256 MB
* `default['jenkins']['master']['listen_address']` - Listen address. Default "127.0.0.1". So the Jenkins application is only reachable from localhost or through Nginx.

### Java

Some attributes that overwrite the [Java cookbook](https://supermarket.chef.io/cookbooks/java) attributes:

* `default['java']['jdk_version']` - Version. Default 7

## Adding plugins

You can add plugins to the `default['jenkins-server']['plugins']` array.

Add a Jenkins plugin "myplugin" like below. You can specify a version. If you want to configure it, set configure to `true`
and specify a cookbook and recipe. Use the `jenkins_script` resource to configure your plugin with a groovy script.
Take a look at the plugin recipes in this cookbook for examples. 

    default['jenkins-server']['plugins']['myplugin'] = {
      'version' => '1.0',
      'configure' => true,
      'cookbook' => 'mycookbook',
      'recipe' => 'myrecipe_plugin_example'
    }

Plugins can be configured with groovy scripts. Test them at your Jenkins instance:
`http://<host>:8080/script`

With the [doInspector method from javaworld.com](http://www.javaworld.com/article/2073679/detecting-class-innards-in-groovy.html)
you can figure out the properties and methods of your plugin. The Jenkins core API documentation
can be found at [http://javadoc.jenkins-ci.org](http://javadoc.jenkins-ci.org).   

    def doInspector(obj) {
      def inspector = new groovy.inspect.Inspector(obj)
      def inspectorReport = new StringBuilder()
      inspectorReport << "Object under inspection "
      inspectorReport << (inspector.isGroovy() ? "IS" : "is NOT") << " Groovy!\n"
      inspectorReport << "METHODS\n"
      def methods = inspector.methods
      methods.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      inspectorReport << "\nMETA METHODS\n"
      def metaMethods = inspector.metaMethods
      metaMethods.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      inspectorReport << "\nPROPERTY INFO\n"
      def properties = inspector.propertyInfo
      properties.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      println inspectorReport
    }

## Usage

### jenkins-server::default

Include `jenkins-server` in your node's `run_list`:

    json
    {
      "run_list": [
        "recipe[jenkins-server::default]"
      ]
    }

The default recipe includes the following recipies:

    if node['jenkins-server']['java']['install']
      include_recipe 'java'
    end
    
    if node['jenkins-server']['ant']['install']
      include_recipe 'ant'
    end
    
    if node['jenkins-server']['git']['install']
      include_recipe 'git'
    end
    
    if node['jenkins-server']['nginx']['install']
      include_recipe 'jenkins-server::nginx'
    end
    
    include_recipe 'jenkins-server::master'
    include_recipe 'jenkins-server::security'
    include_recipe 'jenkins-server::settings'
    include_recipe 'jenkins-server::plugins'
    include_recipe 'jenkins-server::jobs'
    include_recipe 'jenkins-server::composer'
    
## License

The MIT License (MIT)
 
## Authors

Author:: Pieter Vogelaar (pieter@pietervogelaar.nl)
