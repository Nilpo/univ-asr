
# Interface configuration (eth1)
default['static']['ip'] = nil
default['static']['netmask'] = "255.255.255.0"

# Default gateway
default['static']['gateway'] = nil

# Add route to eth1 if necessary
default['static']['route'] = nil

# Interfaces that have DHCP enabled (stop from overwriting resolv.conf)
default['static']['no_peerdns'] = ["eth0"]

# DNS attributes
default['static']['resolv'] = "search"
default['static']['domain'] = "imbcc.pt"
default['static']['nameservers'] = ["172.31.0.1"]
