
# Copy iptables rules file
cookbook_file "/etc/sysconfig/iptables" do
  source "server"
end

# Restart service
service "iptables" do
  action [:restart]
end
