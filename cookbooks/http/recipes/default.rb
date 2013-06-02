
package "httpd"
package "mod_ssl"

# Create directories for main sites
%w{www imob clientes}.each do |site|
  directory "/var/www/imbcc/#{site}/public_html" do
    recursive true
  end
  file "/var/www/imbcc/#{site}/public_html/index.htm" do
    content "O site #{site} ficará disponível brevemente..."
  end
end

# Copy apache configuration
%w{conf/httpd.conf conf.d/ssl.conf}.each do |conf|
  cookbook_file "/etc/httpd/#{conf}" do
    source conf
    mode 0644
  end
end

# Create directories for certificates
%w{certs keys}.each do |dir|
  directory "/etc/httpd/ssl/#{dir}" do
    recursive true
  end
end

# Copy certificates
%w{server.crt ca.crt}.each do |cert|
  cookbook_file "/etc/httpd/ssl/certs/#{cert}" do
    source "pki/certs/#{cert}"
  end
end

# Copy private key
cookbook_file "/etc/httpd/ssl/keys/server.pem" do
  source "pki/keys/server.pem"
  # owner "root"
  # group "root"
  # mode 0700
end

# Start service
service "httpd" do
  action [:enable, :restart]
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
