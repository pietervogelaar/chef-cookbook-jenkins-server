# jenkins-server

This cookbook installs and configures a complete Jenkins server. The Jenkins server and plugins
are highly configurable with attributes in this cookbook.

## Supported Platforms

- CentOS >= 6.6
- Ubuntu >= 14.04

These platforms are supported and tested, but it will probably work on other platforms to.

## Attributes

* `node['jenkins-server']['host']` - Sets the Jenkins host for the Nginx template (optional).
* `node['jenkins-server']['admin']['username']` - Sets the username for the administrator user. Default "admin".
* `node['jenkins-server']['security']['chef-vault']['data_bag']` - Name of the data bag for jenkins users
* `node['jenkins-server']['security']['chef-vault']['data_bag_item']` - ID of the data bag to use as administrator user

...
  
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


    include_recipe 'jenkins-server::packages'
    include_recipe 'jenkins-server::master'
    include_recipe 'jenkins-server::security'
    include_recipe 'jenkins-server::settings'
    include_recipe 'jenkins-server::plugins'

### Adding plugins

You can add plugins to the `default['jenkins-server']['plugins']` array.

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

Add a Jenkins plugin "myplugin" like below. You can specify a version. If you want to configure it, set configure to `true`
and specify a cookbook and recipe. Use the `jenkins_script` resource to configure your plugin with a groovy script.
Take a look at the plugin recipes in this cookbook for examples. 

    default['jenkins-server']['plugins']['myplugin'] = {
      'version' => '1.0',
      'configure' => true,
      'cookbook' => 'mycookbook',
      'recipe' => 'myrecipe_plugin_example'
    }

## License

The MIT License (MIT)
 
## Authors

Author:: Pieter Vogelaar (pieter@pietervogelaar.nl)
