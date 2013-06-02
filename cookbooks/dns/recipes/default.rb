
# Install required packages
%w{bind bind-utils}.each do |bind_pkg|
  package bind_pkg
end

# Clean backups from last run (if available)
execute "clean" do
  user "root"
  command "rm -f /etc/named.conf~ /var/named/external/*{~,rev}"
end

# Create /var/named subdirectories
%w{data internal external}.each do |subdir|
  directory "/var/named/#{subdir}" do
    owner "named"
    group "named"
    mode 0770
    recursive true
  end
end

# Copy configuration file
cookbook_file "/etc/named.conf" do
  source "named.conf"
  group "named"
  mode 0644
end

# Copy internal zone files
%w{imbcc.pt.db 0.16.172.rev 1.16.172.rev 0.31.172.rev}.each do |var_internal_file|
  cookbook_file "/var/named/internal/#{var_internal_file}" do
    source "internal/#{var_internal_file}"
    owner "named"
    group "named"
    mode 0644
  end
end

# Copy external zone files
%w{imbcc.pt.db 0.31.172.rev}.each do |var_external_file|
  cookbook_file "/var/named/external/#{var_external_file}" do
    source "external/#{var_external_file}"
    owner "named"
    group "named"
    mode 0644
  end
end

# Copy script to update DNS with public address
cookbook_file "/root/dns-external.sh" do
  source "dns-external.sh"
  owner "root"
  group "root"
  mode 0770
end

# Listen on our public IP for external requests
execute "/root/dns-external.sh" do
  user "root"
end

# Start DNS service
service "named" do
  action [:enable, :restart]
end

# Change the server's nameserver
include_recipe "networking::resolv"
include_recipe "networking::restart"
