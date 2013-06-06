
# Fetch owncloud repository
# Instructions: http://software.opensuse.org/download/package?project=isv:ownCloud:community&package=owncloud
remote_file "/etc/yum.repos.d/isv:ownCloud:community.repo" do
  source "http://download.opensuse.org/repositories/isv:ownCloud:community/CentOS_CentOS-6/isv:ownCloud:community.repo"
  checksum "56e06bc00e0dcf7dad46239ea09897a70576524824683e678d54c924a9d4e11e"
  mode "0644"
  not_if { ::File.exists?("/etc/yum.repos.d/isv:ownCloud:community.repo")}
end

# Fetch EPEL for dependencies
remote_file "/root/epel-release-6-8.noarch.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
  not_if { ::File.exists?("/root/epel-release-6-8.noarch.rpm")}
  notifies :run, "execute[epel]"
end

# Install EPEL repository
execute "epel" do
  user "root"
  cwd "/root"
  command "rpm -ivh epel-release-6-8.noarch.rpm"
  action :nothing
end

# Install owncloud using EPEL for dependencies
yum_package "owncloud" do
  flush_cache [:before]
  options "--enablerepo=epel"
end

# Add support for LDAP
package "php-ldap"
