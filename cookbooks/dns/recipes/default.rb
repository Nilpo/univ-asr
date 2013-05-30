
# Install required packages
%w{bind bind-utils}.each do |bind_pkg|
  package bind_pkg
end

# Create /var/named subdirectories
%w{data internal external}.each do |subdir|
  directory "/var/named/#{subdir}" do
    owner "named"
    group "named"
    mode 0770
    recursive true
  end
end

# Copy configuration file
cookbook_file "/etc/named.conf" do
  source "named.conf"
  group "named"
  mode 0644
end

# Copy internal zone files
%w{imbcc.pt.db 0.16.172.rev 1.16.172.rev 0.31.172.rev}.each do |var_internal_file|
  cookbook_file "/var/named/internal/#{var_internal_file}" do
    source "internal/#{var_internal_file}"
    owner "named"
    group "named"
    mode 0644
  end
end

# Copy external zone files
%w{imbcc.pt.db 0.31.172.rev}.each do |var_external_file|
  cookbook_file "/var/named/external/#{var_external_file}" do
    source "external/#{var_external_file}"
    owner "named"
    group "named"
    mode 0644
  end
end

service "named" do
  supports :reload => true, :status => true
  action [ :enable, :start ]
end

bash "security" do
  user "root"
  code <<-EOH
    iptables -I INPUT -p udp --dport 53 -j ACCEPT
  EOH
end
