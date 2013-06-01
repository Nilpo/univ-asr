
# Copy ssh configuration files
%w{sshd_config banner.txt}.each do |file|
  cookbook_file "/etc/ssh/#{file}" do
    source "#{file}"
    mode 0600
  end
end

# Restart service
service "sshd" do
  action [:restart]
end
