# zimbra Cookbook

This recipe configures a local server with chef-solo and installs a full
NEW install of Zimbra. Do NOT use this to upgrade Zimbra

Note: This does not install the dns-cache package, and you will need to update
the zimbraMtaMyNetworks setting to your network..

## Requirements

This is built to run on an Oracle 6.6 Kernel in the Oracle Cloud using Zimbra 8.7 RC1. It assumes the standard kernel install and that the /opt/zimbra partition has been mounted and configured on /dev/xvdc

### Platforms

- Oracle Linux 6.6

### Chef

- Chef 12.0 or later

### Cookbooks

- zimbra - This is a self contained recipe.

## Attributes

- Ohai attributes from the OS are used such as node['fqdn'], node['ipaddress'] and node['hostname']

## Usage
chef-solo -c solo.rb -j web.json

### zimbra::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `zimbra` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[zimbra]"
  ]
}
```

## Contributing

TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

submitted by Mark Nichols, mnichols@zimbra.com
Authors: TODO: List authors

