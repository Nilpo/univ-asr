
# Install dhcp package
package "dhcp"

# Configure DHCP Relay
cookbook_file "/etc/sysconfig/dhcrelay" do
  source "relay"
end

# Start service
service "dhcrelay" do
  action [:enable, :restart]
end
