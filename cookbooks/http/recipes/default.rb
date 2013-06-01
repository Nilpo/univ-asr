
package "httpd"

# Create directories for main sites
%w{www imob}.each do |site|
  directory "/var/www/#{site}/public_html" do
    recursive true
  end
end

# Copy apache configuration
cookbook_file "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf"
  mode 0644
  notifies :restart, "service[httpd]", :delayed
end

# Start service
service "httpd" do
  supports :reload => true, :status => true
  action [:enable, :start]
end

# Create users with userdir access
%w{rui nelia paulo}.each do |username|
  user "#{username}"

  directory "/home/#{username}" do
    mode 0711
  end

  directory "/home/#{username}/public_html" do
    owner "#{username}"
    group "#{username}"
    mode 0755
  end
end
