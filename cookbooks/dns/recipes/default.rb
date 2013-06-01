
# Install required packages
%w{bind bind-utils}.each do |bind_pkg|
  package bind_pkg
end

# Create /var/named subdirectories
%w{data internal external}.each do |subdir|
  directory "/var/named/#{subdir}" do
    owner "named"
    group "named"
    mode 0770
    recursive true
    notifies :restart, "service[named]", :delayed
  end
end

# Copy configuration file
cookbook_file "/etc/named.conf" do
  source "named.conf"
  group "named"
  mode 0644
  notifies :restart, "service[named]", :delayed
end

# Copy internal zone files
%w{imbcc.pt.db 0.16.172.rev 1.16.172.rev 0.31.172.rev}.each do |var_internal_file|
  cookbook_file "/var/named/internal/#{var_internal_file}" do
    source "internal/#{var_internal_file}"
    owner "named"
    group "named"
    mode 0644
    notifies :restart, "service[named]", :delayed
  end
end

# Copy external zone files
%w{imbcc.pt.db 0.31.172.rev}.each do |var_external_file|
  cookbook_file "/var/named/external/#{var_external_file}" do
    source "external/#{var_external_file}"
    owner "named"
    group "named"
    mode 0644
    notifies :restart, "service[named]", :delayed
  end
end

# Listen on our public IP for external requests
bash "external" do
  user "root"
  code <<-EOH
    # IP manipulation
    PUBLIC_IP=`ifconfig eth2 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'`
    PUBLIC_NET=`echo $PUBLIC_IP | cut -d. -f1-3`
    HOST_PART=`echo $PUBLIC_IP | cut -d. -f4`
    REV=`echo $PUBLIC_NET | awk -F. '{s="";for (i=NF;i>1;i--) s=s sprintf("%s.",$i);$0=s $1}1'`

    # Update named.conf and zone files
    sed -i~ "s/\\(listen-on port 53\\).*/\\1   { $PUBLIC_IP; 172.31.0.1; 127.0.0.1; };/1g; /DYNAMIC/ { s/0.31.172/$REV/}; s/ \\/\\/ DYNAMIC//" /etc/named.conf
    sed -i~ "s/172.31.0.1/$PUBLIC_IP/" /var/named/external/imbcc.pt.db
    sed -i~ "s/^1\\(.*PTR.*\\)/$HOST_PART\\1/g" /var/named/external/0.31.172.rev
    mv /var/named/external/0.31.172.rev /var/named/external/$REV.rev
  EOH
  notifies :restart, "service[named]", :delayed
end

# Start DNS service
service "named" do
  supports :reload => true, :status => true
  action [:enable, :start]
end

# Change the server's nameserver
include_recipe "networking::resolv"

# Restart network
service "network" do
  action [:restart]
end
