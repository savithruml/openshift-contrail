# Author: SAVITHRU LOKANATH
# Contact: SAVITHRU AT JUNIPER.NET
# Copyright (c) 2017 Juniper Networks, Inc. All rights reserved.

#!/bin/bash

sudo su
passwd
sed -i -e 's/#PermitRootLogin yes/PermitRootLogin yes/g' -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 
service sshd restart
yum install git wget -y
cd /root/
git clone https://github.com/savithruml/openshift-contrail

echo "Successfully updated root password. Try logging into the instance as root user"
