#!/bin/bash

# IP manipulation
PUBLIC_IP=`ifconfig eth2 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'`
PUBLIC_NET=`echo $PUBLIC_IP | cut -d. -f1-3`
HOST_PART=`echo $PUBLIC_IP | cut -d. -f4`
REV=`echo $PUBLIC_NET | awk -F. '{s="";for (i=NF;i>1;i--) s=s sprintf("%s.",$i);$0=s $1}1'`

# Check if IP changed
if [ "$1" = "--check" ]; then
    grep $PUBLIC_IP /etc/named.conf > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Already up to date for IP $PUBLIC_IP!"
        exit 0
    fi
fi

# Recover from backups
echo -n "Recovering from backup... "
declare -a FILES=(/etc/named.conf~ /var/named/external/*~)

for file in "${FILES[@]}"; do
    if [ -f $file ]; then
        new=`echo $file | sed 's/~*$//'`
        mv -f $file $new
    fi
done
echo "done."

# Update named.conf and zone files
echo -n "Updating files... "
sed -i~ "s/\\(listen-on port 53\\).*/\\1   { $PUBLIC_IP; 172.31.0.1; 127.0.0.1; };/1g; /DYNAMIC/ { s/0.31.172/$REV/}; s/ \\/\\/ DYNAMIC//" /etc/named.conf
sed -i~ "s/172.31.0.1/$PUBLIC_IP/" /var/named/external/imbcc.pt.db
sed -i~ "s/^1\\(.*PTR.*\\)/$HOST_PART\\1/g" /var/named/external/0.31.172.rev
mv -f /var/named/external/0.31.172.rev /var/named/external/$REV.rev
echo "done."

# Restart service
service named restart
echo -e "\nYour nameserver is at $PUBLIC_IP"
