
# Configure interface
cookbook_file "/etc/sysconfig/network-scripts/ifcfg-eth1" do
  source "client"
end

# Restart service
service "network" do
  action [:restart]
end
