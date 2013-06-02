#!/bin/bash

# Refresh interface if passed -r argument
if [[ "$*" == *-r* ]]; then
    vagrant ssh dmz -c "sudo ifdown eth2; sudo ifup eth2"
fi

# Update public ip in DNS server
vagrant ssh dmz -c "sudo /root/dns-external.sh --check"
