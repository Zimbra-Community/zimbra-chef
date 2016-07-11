#
# Cookbook Name:: zimbra
# Recipe:: default
#
# Copyright 2016, Synacor, Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe configures a local server with chef-solo and installs a full
# NEW single server instance of Zimbra. It installs with the local hostname and domain name.
# 
# **** Do NOT use this to upgrade Zimbra  ****
#
# Note: This does not install the dns-cache package.

# Assuming an unformated partition /dev/xvdc, that will host /opt/zimbra
# Format, Create, and Mount the /opt/zimbra filesystem on that partition
execute "create_optzimbra" do
  command "mkfs -t ext4 -j -O dir_index -m 2 -i 10240 -J size=400 /dev/xvdc"
  not_if  "grep xvdc /proc/mounts"
end

# Set the appropriate permissions on the directory where Zimbra will be installed
directory '/opt/zimbra' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mount the parition on the new filesystem.
mount "/opt/zimbra" do
  device "/dev/xvdc"
  fstype "ext4"
  action [:mount, :enable]
end

# Set the attributes of the file system to optimize for writes
bash 'optimize_filesystem' do
  code <<-EOH
    chattr -R +D /opt/zimbra
    EOH
end

# Modify the Zimbra Installation File with local parameters for installation
template "/root/oracle-cloud-zcs87-config-v1.txt" do
  source "oracle-cloud-zcs87-config-v1.erb"
  owner "root"
  group "root"
  mode "0644"
end

# Update hosts file with IP address and hostname
template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
end

# Update sysctl.conf file with Zimbra Parameters
template "/etc/sysctl.conf" do
  source "sysctl.erb"
  owner "root"
  group "root"
  mode 0644
end

# Download the Zimbra Binary
remote_file "/root/zcs-NETWORK-8.7.0_GA_1659.RHEL6_64.20160628192634.tgz" do
  source "https://files.zimbra.com/downloads/8.7.0_GA/zcs-NETWORK-8.7.0_GA_1659.RHEL6_64.20160628192634.tgz"
  mode 0644
end

# Download a Zimbra License
remote_file "/root/ZCSLicense.xml" do
  source "https://license.zimbra.com/zimbraLicensePortal/public/STLicense?IssuedToName=Oracle&IssuedToEmail=noone@zimbra.com"
  mode 0644
end

execute 'extract_zimbra_tar' do
  cwd "/root"
  command "tar xzf /root/zcs-NETWORK-8.7.0_GA_1659.RHEL6_64.20160628192634.tgz"
end

# Install a Zimbra recommended package
package "libreoffice-headless" do
   action :install
end 

# Run the Zimbra Install Script
execute "install" do
  cwd "/root/zcs-NETWORK-8.7.0_GA_1659.RHEL6_64.20160628192634"
  command "bash /root/zcs-NETWORK-8.7.0_GA_1659.RHEL6_64.20160628192634/install.sh -l /root/ZCSLicense.xml /root/oracle-cloud-zcs87-config-v1.txt"
end
