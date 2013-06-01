
# Copy iptables rules file
cookbook_file "/etc/sysconfig/iptables" do
  source "iptables"
end

# Restart service
service "iptables" do
  action [:restart]
end
