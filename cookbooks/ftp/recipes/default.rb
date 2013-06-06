
# Install package
package "vsftpd"

# Copy configuration files
%w{vsftpd.conf vsftpd.pem}.each do |file|
  cookbook_file "/etc/vsftpd/#{file}" do
    source "#{file}"
  end
end

# Configure
ruby_block "iptables_config" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/sysconfig/iptables-config")
    rc.search_file_replace_line(/IPTABLES_MODULES/, 'IPTABLES_MODULES="ip_conntrack_ftp"')
    rc.write_file
  end
end

# Enable service
service "vsftpd" do
  action [:enable, :restart]
end
