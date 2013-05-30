
# Install dhcp package
package "dhcp"

# Find which network
network = (node.static.domain == "imob.imbcc.pt" && "filial2") || "sede"

# Install dhcp configuration file
cookbook_file "/etc/dhcp/dhcpd.conf" do
  source "#{network}.conf"
end

# Define which interface to use for DHCP
# http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch08_:_Configuring_the_DHCP_Server#Listening
file "/etc/sysconfig/dhcpd" do
  content "DHCPDARGS=eth1"
end

# Add route to reply to DHCP requests (multiple NICs)
# http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch08_:_Configuring_the_DHCP_Server#DHCP_Servers_with_Multiple_NICs
file "/etc/sysconfig/network-scripts/route-eth1" do
  content "255.255.255.255/32 dev eth1"
end

# Start service
service "dhcpd" do
  action [:enable, :start]
end
