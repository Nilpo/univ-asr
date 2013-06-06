
# Install LDAP packages
%w{openldap openldap-clients openldap-servers}.each do |pckg|
  package pckg
end

# Stop service before writing config files
service "slapd" do
  action [:enable, :stop]
end

# Root user
manager = "cn=Manager,#{node.openldap.basedn}"
password = "imbcc"

# Configuration directory
config_dir = "/etc/openldap/slapd.d/cn=config"

# Configure
ruby_block "slapd_config" do
  block do
    password_hash = Mixlib::ShellOut.new(%Q[slappasswd -s imbcc]).run_command.stdout.strip!
    Chef::Log.info("Generated new LDAP root password: #{password_hash}")

    rc = Chef::Util::FileEdit.new("#{config_dir}/olcDatabase={2}bdb.ldif")
    rc.search_file_replace_line(/olcSuffix:/, "olcSuffix: #{node.openldap.basedn}")
    rc.search_file_replace_line(/olcRootDN:/, "olcRootDN: #{manager}")
    rc.insert_line_after_match(/olcRootDN/, "olcRootPW: #{password_hash}")
    rc.write_file

    rc = Chef::Util::FileEdit.new("#{config_dir}/olcDatabase={1}monitor.ldif")
    rc.search_file_replace(/dn.base="cn=[\w]+,dc=[\w-]+,dc=[\w]+"/, "dn.base=\"#{manager}\"")
    rc.write_file
  end
  not_if "grep olcRootPW #{config_dir}/olcDatabase={2}bdb.ldif"
end

# Start service
service "slapd" do
  action [:start]
end

# Add entries
ldif_dir = "/vagrant/cookbooks/ldap/files/default"
%w{
  imbcc
  users
  groups
  users/margarida
  users/nelia
  users/paulo
  users/psantos
  users/rui
  groups/webdesign
  groups/imob
}.each do |ldif|
  execute "add_#{ldif.gsub('/', '_')}" do
    cwd ldif_dir
    command "ldapadd -f #{ldif_dir}/#{ldif}.ldif -D #{manager} -w #{password}"
    not_if "bash -c 'ldapsearch -x -LLL -b $(head -1 #{ldif_dir}/#{ldif}.ldif | cut -d\\  -f2)'", :cwd => ldif_dir
  end
end


