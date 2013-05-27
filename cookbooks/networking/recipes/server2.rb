
# Set the default gateway
bash "gateway" do
  user "root"
  code "echo GATEWAY=172.16.2.254 >> /etc/sysconfig/network"
end

# Configure interface
cookbook_file "/etc/sysconfig/network-scripts/ifcfg-eth1" do
  source "server2"
end

# Restart service
service "network" do
  action [:restart]
end
