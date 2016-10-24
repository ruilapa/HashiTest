#!/bin/bash

set -x

update-ca-trust force-enable

alias yum='yum --releasever=7'

yum -y install yum-plugin-versionlock yum-utils kernel-devel postfix

yum versionlock kernel kernel-devel kernel-doc kernel-firmware kernel-headers

touch /var/lock/subsys/local

EMAIL=rui.lapa@ruilapa.net
# Send a summary of what happened in the installation.
FILES=`ls /var/log/boot.log /root/install-post.log \
          /root/install.log /root/install.log.syslog /var/log/vboxadd-install.log /var/log/yum_install.log `
(echo -en "To: ${EMAIL}\r\n" ;
 echo -en "Subject: CentOS Installation Summary\r\n\r\n" ;
 echo -en "Full package list:\r\n\r\n" ;
 rpm -qa | sort ;
 for f in ${FILES}; do
   echo -en "\r\n\r\n\$f:\r\n\r\n" ;
   sed 's/^/    /' $f && rm -f $f ;
 done ) | sendmail ${EMAIL}

sleep 10 # Give postfix a bit of time to send the email.
service postfix stop # Kill postfix so we can clear logs.

rm -f /var/log/dmesg.old /var/log/anaconda.ifcfg.log \
      /var/log/anaconda.log /var/log/anaconda.program.log \
      /var/log/anaconda.storage.log /var/log/anaconda.syslog \\
      /var/log/anaconda.yum.log /root/anaconda-ks.cfg \
      /var/log/vboxadd-install.log /var/log/vbox-install-x11.log \
      /var/log/VBoxGuestAdditions.log /var/log/vboxadd-install-x11.log
echo -n | tee /var/log/dmesg /var/log/maillog /var/log/lastlog \
              /var/log/secure /var/log/yum.log /var/log/yum_install.log >/var/log/cron

chkconfig --level 2345 auditd on
chkconfig --level 2345 crond on
chkconfig --level  345 netfs on
chkconfig --level  345 nfslock on
chkconfig --level 2345 rpcbind on
chkconfig --level  345 rpcgssd on
chkconfig --level  345 rpcidmapd on
chkconfig --level 2345 sshd on

rm -rf /tmp/* /tmp/.[^.]+
dd if=/dev/zero of=/tmp/clean || rm -f /tmp/clean

swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart
dd if=/dev/zero of=$swappart
mkswap $swappart

yum -y remove kernel-devel
