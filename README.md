This recipe (assuming chef-solo) is for a fresh single server install of Zimbra.

Additional configuration of Zimbra is needed after the installation is complete.

In the Oracle cloud, chef can be called automatically when an instance is created with an Orchestration.

During the Zimbra Installation process, a 60-day trial license is installed and must be updated by the Zimbra Administrator to continue using Zimbra.

Contact a local Zimbra Partner or Reseller to purchase your license. https://www.zimbra.com/partners/
Introduction

Chef-solo can be downloaded and installed on an existing Linux installation. If you choose this approach, you will want to edit the recipe and template files to adjust for parameters in your environment.

This cookbook is based on Oracle Linux 6.6 in the Oracle Cloud. The configuration should also work on RHEL/Centos 6.x with a few minor changes.

Zimbra can be installed using a configuration file that defines needed installation parameters. The chef process uses the template feature to create the configuration file with the correct parameters. You can modify the template file to customize your automated install if you like before you run chef.

The Chef Zimbra recipe makes many assumptions about the layout of the OS and hardware... proceed with caution!!

Execute chef-solo as root

Download and customize the chef templates to reflect your operating system configuration. 

The instructions shown here allow you to run the complete process. As root user:

cd ~
curl -L https://www.opscode.com/chef/install.sh | bash
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv chef-chef-repo* chef-repo
rm master -f
cd chef-repo/
mkdir .chef
echo "cookbook_path [ '/root/chef-repo/cookbooks' ]" > .chef/knife.rb
knife cookbook create zimbra
wget {git-repo of this recipe}
unzip chef-solo.tar.zip
tar xvf chef-solo.tar 

Edit the files, especially the download, extract, and install portions in the recipe, to get the latest version of Zimbra

chef-solo -c solo.rb -j web.json

Additional Zimbra Configuration after installation

Login to the new server with ssh and set the Zimbra Admin Password

   zmprov sp admin@hostname.oracle-cloud-domain.internal Y0urN3wP@$$

Login to the Admin Console to
   Activate the license or install your license file from Zimbra and activate it.
   Configure Zimbra with your domain name and accounts.
   OPTIONAL: Install a commercial certificate
If needed, create an account with an outbound SMTP service such as Sendgrid, Mailjet, or Mailgun. Configure the Zimbra MTA service to relay outbound mail through that service.
   Add a separate backup partition (created with a separate storage orchestration), mount it in the instance, and modify the zimbra backup configuration to point to this partition.
   Migrate your data.
   Update your DNS and MX records when you are ready to cutover.
