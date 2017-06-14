# RedHat Openshift Origin with Juniper Contrail Networking

## RESOURCES

   * [OpenShift Blog](http://www.opencontrail.org/red-hat-openshift-container-platform-with-opencontrail-networking/)
   
   * [OpenShift-Contrail Demo](https://www.youtube.com/watch?v=_vdwY1ux_gg)

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

## INSTALL OPENSHIFT

    (ansible-node)# ssh-keygen –t rsa
    (ansible-node)# ssh-copy-id root@localhost
    (ansible-node)# ssh-copy-id root@<master-node>
    (ansible-node)# ssh-copy-id root@<slave-node>

    (ansible-node)# cd /root
    (ansible-node)# git clone https://github.com/savithruml/openshift-contrail
    (ansible-node)# git clone https://github.com/openshift/openshift-ansible

    (ansible-node)# yes | cp /root/openshift-contrail/openshift/install-files/ose-install openshift-ansible/inventory/byo
    (ansible-node)# yes | cp /root/openshift-contrail/openshift/install-files/ose-prerequisites.yml openshift-ansible/inventory/byo
    
         Populate /root/openshift-ansible/inventory/byo/ose-install with all hosts (master & slave) information

    (ansible-node)# cd /root/openshift-ansible
    (ansible-node)# ansible-playbook -i inventory/byo/ose-install playbooks/byo/openshift_facts.yml
    (ansible-node)# ansible-playbook -i inventory/byo/ose-install playbooks/byo/config.yml

## INSTALL CONTRAIL

    Download Contrail-Ansible package & Contrail-Docker images, 
    
         PACKAGE: contrail-ansible-4.0.0.0-20.tar.gz                 (Ubuntu 14.04)
         IMAGES:  contrail-kubernetes-docker-images_4.0.0.0-20.tgz   (Ubuntu 14.04)

    (ansible-node)# cd /root
    (ansible-node)# mkdir contrail-ansible && cd contrail-ansible
    (ansible-node)# cp /root/contrail-ansible-4.0.0.0-20.tar.gz . && tar -xvzf contrail-ansible-4.0.0.0-20.tar.gz
    (ansible-node)# mkdir playbooks/container_images && cd playbooks/container_images
    (ansible-node)# cp /root/contrail-kubernetes-docker-images_4.0.0.0-20.tgz . && tar -xvzf contrail-kubernetes-docker-images_4.0.0.0-20.tgz
    
    (ansible-node)# cd /root/contrail-ansible/playbooks
    (ansible-node)# yes | cp /root/openshift-contrail/contrail/install-files/all.yml inventory/my-inventory/group_vars
    (ansible-node)# yes | cp /root/openshift-contrail/contrail/install-files/hosts inventory/my-inventory
    
         Populate /root/contrail-ansible/playbooks/inventory/my-inventory/hosts with all hosts (Config/Control/Analytics/Compute) information
         Populate /root/contrail-ansible/playbooks/inventory/my-inventory/group_vars/all.yml with Contrail related information
 
    (ansible-node)# ansible-playbook -i inventory/my-inventory site.yml
    
 ## INIT CONTRAIL/OPENSHIFT
 
    * Create a new project & move into the project context
    
         (master-node)# oc login -u system:admin
         (master-node)# oc new-project juniper 
         (master-node)# oc project juniper

    * Create a service account to access the APIs
         
         (master-node)# oc create serviceaccount useroot
    
    * Bind the service account to the role

         (master-node)# oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:juniper:useroot

    * Add the user to a “privileged” security context constraint

         (master-node)# oadm policy add-scc-to-user privileged system:serviceaccount:juniper:useroot
         
    * Assign cluster-admin role to admin user
    
         (master-node)# oadm policy add-cluster-role-to-user cluster-admin admin

    * Get a token assigned to a service account
         
         (master-node)# oc serviceaccounts get-token useroot
         
    * Copy this token. Login to "Contrail-kube-manager" container & paste this token
    
         (master-node)# docker exec -it contrail-kube-manager bash
         
               Add the token. Also, make sure cluster project dict object is empty
               
               (contrail-kube-manager)# vi /etc/contrail/contrail-kubernetes.conf
               
                     [VNC]
                     ...
                     cluster_project = {}
                     ...
                     token = <paste your token here>
               
               Restart contrail-kube-manager service
               
               (contrail-kube-manager)# supervisorctl -s unix:///var/run/supervisord_kubernetes.sock supervisor restart all
               (contrail-kube-manager)# supervisorctl -s unix:///var/run/supervisord_kubernetes.sock supervisor status
               (contrail-kube-manager)# exit
  
    * Create a password for admin user to login to the UI
    
         (master-node)# htpasswd /etc/origin/master/htpasswd admin
         (master-node)# oc login -u admin
         
    * Login to the Web-UI
    
         Contrail Web-UI:     https://<master-node-public-IP>:8143
         OpenShift Web-UI:    https://<master-node-public-IP>:8443
         
 
   
