
# Forward packets (act like a router)
# http://www.ducea.com/2006/08/01/how-to-enable-ip-forwarding-in-linux/
bash "forwarding" do
  user "root"
  code <<-EOH
    sed -i~ "s/\\(net.ipv4.ip_forward = \\)0/\\11/" /etc/sysctl.conf
  EOH
end

# Firewall rules
file "/etc/sysconfig/iptables" do
  content <<-EOH.gsub(/^ {4}/, '')
    *nat
    :PREROUTING ACCEPT [0:0]
    :POSTROUTING ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    -A POSTROUTING -o eth0 -j MASQUERADE
    COMMIT

    *filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A INPUT -p icmp -j ACCEPT
    -A INPUT -i lo -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
    -A INPUT -j REJECT --reject-with icmp-host-prohibited
    COMMIT
  EOH
end

# Network sede
ifconfig "172.16.0.254" do
  mask "255.255.255.0"
  device "eth1"
  onboot "yes"
end

# Network filial1
ifconfig "172.16.1.254" do
  mask "255.255.255.0"
  device "eth2"
  onboot "yes"
end

# Network filial2
ifconfig "172.16.2.254" do
  mask "255.255.255.0"
  device "eth3"
  onboot "yes"
end

# Network dmz
ifconfig "172.31.0.254" do
  mask "255.255.255.0"
  device "eth4"
  onboot "yes"
end

# Restart services
%w{network iptables}.each do |service|
  service service do
    action [:restart]
  end
end
