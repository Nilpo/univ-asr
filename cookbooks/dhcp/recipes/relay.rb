
# Install dhcp package
package "dhcp"

# Configure DHCP Relay
cookbook_file "/etc/sysconfig/dhcrelay" do
  source "relay"
  notifies :restart, "service[dhcrelay]", :delayed
end

# Start service
service "dhcrelay" do
  action [:enable, :start]
end
