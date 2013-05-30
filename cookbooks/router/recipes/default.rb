
# Forward packets (act like a router)
# http://www.ducea.com/2006/08/01/how-to-enable-ip-forwarding-in-linux/
bash "forwarding" do
  user "root"
  code <<-EOH
    iptables -D FORWARD 1
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    sysctl -w net.ipv4.ip_forward=1
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
