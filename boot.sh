#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
/usr/sbin/useradd student1
echo student1:Fortinet1! | chpasswd
usermod -aG sudo student1
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
echo "Wait for Internet access through the FGTs"
while ! curl --connect-timeout 3 "http://www.google.com" &> /dev/null
    do continue
done
apt-get update -y
#install apache2
apt-get install -y apache2
service apache2 restart
