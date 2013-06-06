
# Install LDAP packages
%w{openldap openldap-clients nss-pam-ldapd}.each do |pckg|
  package pckg
end
