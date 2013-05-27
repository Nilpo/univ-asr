
# Install dhcp package
package "dhcp"

# Install dhcp configuration file
cookbook_file "/etc/dhcp/dhcpd.conf" do
  source "sede/server/dhcpd.conf"
end

# Define which interface to use for DHCP
# http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch08_:_Configuring_the_DHCP_Server#Listening
cookbook_file "/etc/sysconfig/dhcpd" do
  source "sede/server/sysconfig"
end

# Add route to reply to DHCP requests (multiple NICs)
# http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch08_:_Configuring_the_DHCP_Server#DHCP_Servers_with_Multiple_NICs
cookbook_file "/etc/sysconfig/network-scripts/route-eth1" do
  source "sede/server/route"
end

# Start service
service "dhcpd" do
  action [:enable, :start]
end
