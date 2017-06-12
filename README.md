# RedHat Openshift Origin with Juiper Contrail Networking

## LAUNCH INSTANCES ON AWS

    * Ansible Node  (x1)
    
        IMAGE:      Centos 7.3
        FLAVOR:     t2.micro
        DISK:       20 GB
        SEC GRP:    Allow all traffic from everywhere
    
    * Master Node   (x1)
    
        IMAGE:      Centos 7.3
        FLAVOR:     t2.xlarge
        DISK:       250 GB
        SEC GRP:    Allow all traffic from everywhere
    
    * Slave Node    (x1)
    
        IMAGE:      Centos 7.3
        FLAVOR:     t2.xlarge
        DISK:       250 G
        SEC GRP:    Allow all traffic from everywhere

**NOTE:** Make sure to launch the instances in the same subnet & remember to select the *auto-assign public IP* option

## ENABLE ROOT-SSH ACCESS

    Run these commands on all nodes. This will enable root access with password
    
    (all-nodes)# sudo su
    (all-nodes)# passwd
    (all-nodes)# sed -e 's/#PermitRootLogin yes/PermitRootLogin yes/g' -e 's/PasswordAuthentication no/PasswordAuthentication                  yes/g' /etc/ssh/sshd_config 
    (all-nodes)# service sshd restart
    (all-nodes)# yum install git epel-release -y
    (all-nodes)# logout
    
    Logout & login as root user

## INSTALL DEPENDENCIES
    
    (ansible-node)# yum install ansible pyOpenSSL python-cryptography python-lxml -y

    (master-node)# yum install kernel-devel kernel-headers -y && reboot

    (slave-node)# yum install kernel-devel kernel-headers nfs-utils socat -y && reboot

### INSTALL OPENSHIFT

    (ansible-node)# ssh-keygen –t rsa
    (ansible-node)# ssh-copy-id root@localhost
    (ansible-node)# ssh-copy-id root@<master-node>
    (ansible-node)# ssh-copy-id root@<slave-node>

    (ansible-node)# cd /root
    (ansible-node)# git clone https://github.com/savithruml/openshift-contrail
    (ansible-node)# git clone https://github.com/openshift/openshift-ansible

    (ansible-node)# yes | cp /root/openshift-contrail/openshift/install-files/ose-install openshift-ansible/inventory/byo
    (ansible-node)# yes | cp /root/openshift-contrail/openshift/install-files/ose-prerequisites.yml openshift-ansible/inventory/byo
    
         Modify /root/openshift-contrail/openshift/install-files/ose-install with all hosts (master & slave) information

    (ansible-node)# cd /root/openshift-ansible
    (ansible-node)# ansible-playbook -i inventory/byo/ose-install playbooks/byo/openshift_facts.yml
    (ansible-node)# ansible-playbook -i inventory/byo/ose-install playbooks/byo/config.yml

## INSTALL CONTRAIL

    (ansible-node)# cd /root
    (ansible-node)# mkdir contrail-ansible && cd contrail-ansible
    (ansible-node)# scp <contrail-docker>
    (ansible-node)# tar -xvzf contrail-ansible-4.0.0.0-20.tar.gz
    
    (ansible-node)# yes | cp /root/openshift-contrail/contrail/install-files/all.yml playbooks/inventory/my-inventory/group_vars
    (ansible-node)# yes | cp /root/openshift-contrail/contrail/install-files/hosts playbooks/inventory/my-inventory
    
    (ansible-node)# ansible-playbook -i inventory/my-inventory site.yml
