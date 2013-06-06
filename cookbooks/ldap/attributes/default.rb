
default['openldap']['domain'] = "imbcc.pt"

default['openldap']['basedn'] = "dc=#{node['openldap']['domain'].split('.').join(",dc=")}"
default['openldap']['server'] = "ldap.#{node['openldap']['domain']}"
default['openldap']['rootpw'] = nil

# File and directory locations for openldap.
default['openldap']['dir']        = "/etc/openldap"
default['openldap']['run_dir']    = "/var/run/openldap"
default['openldap']['module_dir'] = "/usr/lib64/openldap"

default['openldap']['ssl_dir'] = "#{openldap['dir']}/ssl"
default['openldap']['cafile']  = "#{openldap['ssl_dir']}/ca.crt"
default['openldap']['slapd_type'] = "master"

# Auth settings for Apache
if node['openldap']['basedn'] && node['openldap']['server']
  default['openldap']['auth_type']   = "openldap"
  default['openldap']['auth_binddn'] = "ou=users,#{openldap['basedn']}"
  default['openldap']['auth_bindpw'] = nil
  default['openldap']['auth_url']    = "ldap://#{openldap['server']}/#{openldap['auth_binddn']}?uid?sub?(objectClass=*)"
end
