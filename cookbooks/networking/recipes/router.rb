
# Check for static configuration or DHCP
if node['static']['ip']
  include_recipe "conf"

  # Set basic static networking
  if node['static']['gateway']
    conf_plain_file "/etc/sysconfig/network" do
      pattern /GATEWAY/
      new_line "GATEWAY=#{node['static']['gateway']}"
      action :insert_if_no_match
    end

  end

  # Add a route if necessary
  if node['static']['route']
    file "/etc/sysconfig/network-scripts/route-eth1" do
      content "#{node['static']['route']} dev eth1"
    end
  end

  # Configure internal network interface
  template "/etc/sysconfig/network-scripts/ifcfg-eth1" do
    source "ifcfg-eth1.erb"
  end

  # Stop resolv.conf overwrite by DHCP enabled interfaces
  node['static']['no-peerdns'].each do |device|
    conf_plain_file "/etc/sysconfig/network-scripts/ifcgf-#{device}" do
      pattern /PEERDNS/
      new_line "PEERDNS=no"
      action :insert_if_no_match
    end
  end

  # Set domain and nameserver in resolv.conf
  template "/etc/resolv.conf" do
    source "resolv.erb"
  end

else
  # Configure dhcp
  file "/etc/sysconfig/network-scripts/ifcfg-eth1" do
    content <<-EOH
      BOOTPROTO=dhcp
      ONBOOT=yes
      DEVICE=eth1
    EOH
  end
end

# Restart service
service "network" do
  action [:restart]
end
