
# Install dhcp package
package "dhcp"

# Install dhcp configuration file
cookbook_file "/etc/dhcp/dhcpd.conf" do
  source "dhcpd.conf"
  mode 0644
  owner "root"
  group "root"
end

# Define which interface to use for dhcp
cookbook_file "/etc/sysconfig/dhcpd" do
  source "sysconfig"
  mode 0644
  owner "root"
  group "root"
end

# Start service
service "dhcpd" do
  action [:enable, :start]
end
