#!/bin/bash
#
# Utility to update the DMZ's DNS server with the public
# IP in case it changed, or even to print the current
# attributed IP to use on the host's list of nameservers.

# Refresh interface if passed -r argument
if [[ "$*" == *-r* ]]; then
    vagrant ssh dmz -c "sudo ifdown eth2; sudo ifup eth2"
fi

# Update public ip in DNS server
vagrant ssh dmz -c "sudo /root/dns-external.sh --check"
