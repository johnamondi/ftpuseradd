#!/bin/bash
echo 'Please enter the site locaition:'
read LOCATION

##glad this is working


echo 'Please enter the site name:'
read SITENAME

echo 'Please enter a username'
read SFTPUSER

#Checking Apache group, Debian based or RHEL.
if [ -f /etc/redhat-release ]; then
        GROUP=apache
   else
        GROUP=www-data
fi
##
if [ -d $LOCATION ]; then
echo "The path $LOCATION is exist!!"
groupadd sftponly #exec 2>/dev/null
useradd -s /sbin/nologin $SFTPUSER #exec 2>/dev/null
usermod -G$GROUP,sftponly $SFTPUSER
mkdir -p /home/$SFTPUSER/$SITENAME
chown root:root /home/$SFTPUSER
#chown $SFTPUSER:$GROUP /home/$SFTPUSER/$SITENAME
chmod 755 /home/$SFTPUSER
echo "$LOCATION /home/$SFTPUSER/$SITENAME none rw,bind,nobootwait 0 0" >> /etc/fstab
mount $LOCATION
chown $SFTPUSER:$GROUP /home/$SFTPUSER/$SITENAME
echo "$SFTPUSER:$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)" >> /tmp/passwords.txt
cat /tmp/passwords.txt | chpasswd
echo "  "
echo "Your site $SITENAME files has been jailed into /home/$SFTPUSER"
echo "Your domain user $SFTPUSER's password is `cat /tmp/passwords.txt`"
echo " "
rm -rf /tmp/passwords.txt
else
echo "Your domain $LOCATION does not exist!!"
fi
#EOT
