
include_recipe "conf"

# Stop resolv.conf overwrite by DHCP enabled interfaces
node.static.no_peerdns.each do |device|
  conf_plain_file "/etc/sysconfig/network-scripts/ifcfg-#{device}" do
    pattern /PEERDNS/
    new_line "PEERDNS=no"
    action :insert_if_no_match
      notifies :restart, "service[network]", :delayed
  end
end

# Set domain and nameserver in resolv.conf
template "/etc/resolv.conf" do
  source "resolv.erb"
  notifies :restart, "service[network]", :delayed
end
