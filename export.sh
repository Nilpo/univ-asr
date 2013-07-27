#!/bin/bash
#
# This script exports all the relevant configuration files from
# each of the 7 VMs into a folder, grouped by network and name
# of the VM. This makes the final delivery so that the teacher
# doesn't need to install and run Vagrant to evaluate the work.

# Folder for the final delivery
: ${DEPLOY=release}

# Folder inside $DEPLOY to export files form the VMs
: ${EXPORT=export}

# Which VM to update?
UPDATE="all"

# Suppress errors by default (unless a -d argument is passed to the script)
DEBUG="2> /dev/null"

# Boolean to indicate if we should clean the whole $DEPLOY dir
RESET=true

# Process script arguments:
#  -d             Don't suppress errors (debug)
#  -u [vm-name]   Don't reset $DEPLOY and optionally update only one vm (update)
#
while getopts :du: opt; do
    case $opt in
        d) DEBUG="";;
        u) UPDATE=$OPTARG; RESET=false;;
        :) RESET=false
    esac
done

# Archive our vagrant project (master branch) to $DEPLOY
# Pass a -u argument (update) to the script to skip reseting
if $RESET; then
    echo -n "Resetting... "
    mkdir -p $DEPLOY
    rm -rf $DEPLOY/*
    git archive master | tar -x -C $DEPLOY
    rm $DEPLOY/.gitignore
    echo "Done!"
fi

# Utility that runs the cp command inside the VMs
#
# Arguments:
#  1 - Vagrant's [vm-name] argument
#  2 - Container for the vm (i.e. intnet name appended by a slash)
#  * - All other arguments are the list of files to copy
#
function vm_cp {
    # Check if this VM is to be exported, else skip
    if [ "$UPDATE" != "all" -a "$UPDATE" != "$1" ]; then
        return 0
    fi

    # Declare variables
    local vm=$1
    local target=$DEPLOY/$EXPORT/$2$1

    # Make sure target is clean and $@ is the list of files to copy
    shift $((2))
    mkdir -p "$target"
    rm -rf "$target/*"

    # Begin exporting
    echo "Exporting VM: $vm..."
    vagrant ssh $vm -c "sudo cp -rv --parents $@ /vagrant/$target $DEBUG"

    # Print an empty line
    echo
}

################## Define files to copy for each VM ##################

vm_cp dmz dmz/ \
        "/etc/sysconfig/network-scripts/{ifcfg,route}-eth{1,2}" \
        "/etc/sysconfig/{network,iptables}" \
        "/etc/{named,resolv}.conf*" \
        "/var/named/{internal,external}" \
        "/etc/httpd/conf/httpd.conf" \
        "/etc/httpd/conf.d/ssl.conf" \
        "/etc/httpd/ssl" \
        "/var/www/imbcc" \
        "/etc/passwd" \
        "/home/{rui,nelia,paulo}/public_html" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/vsftpd/vsftpd.{conf,pem}" \
        "/etc/sysconfig/iptables-config" \

vm_cp router "" \
        "/etc/sysconfig/network-scripts/ifcfg-eth*" \
        "/etc/sysconfig/network" \
        "/etc/sysconfig/dhcrelay" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \
        "/etc/sysctl.conf" \

vm_cp server sede/ \
        "/etc/sysconfig/network-scripts/{ifcfg,route}-eth1" \
        "/etc/sysconfig/{network,dhcpd}" \
        "/etc/dhcp/dhcpd.conf" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \
        "/etc/openldap/slapd.d/cn\=config/olcDatabase\={\{2\}bdb,\{1\}monitor}.ldif" \

vm_cp client sede/ \
        "/etc/sysconfig/network-scripts/ifcfg-eth1" \
        "/etc/sysconfig/network" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \

vm_cp client_f1 filial1/ \
        "/etc/sysconfig/network-scripts/ifcfg-eth1" \
        "/etc/sysconfig/network" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \

vm_cp server2 filial2/ \
        "/etc/sysconfig/network-scripts/{ifcfg,route}-eth1" \
        "/etc/sysconfig/{network,dhcpd}" \
        "/etc/dhcp/dhcpd.conf" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \

vm_cp client_f2 filial2/ \
        "/etc/sysconfig/network-scripts/ifcfg-eth1" \
        "/etc/sysconfig/network" \
        "/etc/ssh/{sshd_config,banner.txt}" \
        "/etc/sysconfig/iptables" \

echo "Done!"
