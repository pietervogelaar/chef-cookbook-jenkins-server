# jenkins-server

This cookbook installs and configures a complete Jenkins server.

## Supported Platforms

CentOS 7.0, Ubuntu 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['jenkins-server']['admin']['username']</tt></td>
    <td>String</td>
    <td>Admin username</td>
    <td><tt>admin</tt></td>
  </tr>
</table>

## Usage

### jenkins-server::default

Include `jenkins-server` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[jenkins-server::default]"
  ]
}
```

## License

The MIT License (MIT)
 
## Authors

Author:: Pieter Vogelaar (pieter@pietervogelaar.nl)
