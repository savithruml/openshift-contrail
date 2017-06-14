# LAB 1 - Developer Workflow

## INTRODUCTION

This guide will demonstrate,

* How to create a new project in OpenShift
* Launch your first application
* Learn how to trigger new builds/images when you make your first Github commit

## RESOURCES

   * [OpenShift Blog](http://www.opencontrail.org/red-hat-openshift-container-platform-with-opencontrail-networking/)
   
   * [OpenShift-Contrail Demo](https://www.youtube.com/watch?v=_vdwY1ux_gg)

## TRY IT OUT

* [Sign up](https://manage.openshift.com/) for OpenShift online

* [Sign up](https://github.com) for a GitHub account if you don't have one

* Login to OpenShift online<br /><br />Click **Open Web Console**
<br /><br />![Web Console](https://github.com/savithruml/openshift-contrail/blob/master/images/login-to-console.png)

* Click **New Project** 
<br /><br />![New Project](https://github.com/savithruml/openshift-contrail/blob/master/images/new-project.png)

* Provide a unique _name, display name_<br /><br />Click **Create**
<br /><br />![Project Info](https://github.com/savithruml/openshift-contrail/blob/master/images/project-info.png)

* Click on **Add to Project**<br /><br />Select **Python** under _Browse Catalog_<br /><br />Select **Django + PostgreSQL (Persistent)**
<br /><br />![Add to project](https://github.com/savithruml/openshift-contrail/blob/master/images/catalog.png)
<br /><br />![Python Django](https://github.com/savithruml/openshift-contrail/blob/master/images/python-django-1.png)

* Login to Github<br /><br />Fork `https://github.com/openshift/django-ex`<br /><br />You must now have your own **django-ex** repository (`https://github.com/<your-github-username>/django-ex`)

* Copy the **URL** `https://github.com/<your-github-username>/django-ex` & go back to OpenShift UI

* In the window **My-Project > Add to Project > Catalog > Django + PostgreSQL (Persistent)** add your Github **URL** to the **Git Repository URL** field<br /><br />Click **Create**
<br /><br />![GitHub URL](https://github.com/savithruml/openshift-contrail/blob/master/images/python-django-2.png)

* In the next window, you will be given instructions to download the OpenShift client & also to create your first project. There is also a **URL** under **Making code changes** block<br /><br />Save this **URL**
<br /><br />![Continue](https://github.com/savithruml/openshift-contrail/blob/master/images/launch-app.png)

* Go to `https://github.com/<your-github-username>/django-ex/settings/hooks`<br /><br />Paste the **URL** you saved from the previous step into the **Payload URL** field<br />Change **Content-type** to **application/json**<br /><br />Click **Add Webhook**
<br /><br />![Webhook-1](https://github.com/savithruml/openshift-contrail/blob/master/images/webhook.png)
<br /><br />![Webhook-2](https://github.com/savithruml/openshift-contrail/blob/master/images/webhooks-2.png)

* A build should've been started by now. After the build has completed, you will find a **URL** in the **Overview** tab in OpenShift UI<br /><br />Clicking the **URL** should open your **django web application**
<br /><br />![Build-app](https://github.com/savithruml/openshift-contrail/blob/master/images/deploy-1.png)
<br /><br />![app-live](https://github.com/savithruml/openshift-contrail/blob/master/images/app-live-1.png)

* Make some changes to the code, either in Github UI or on your local machine<br /><br />For example change the header in<br />`https://github.com/<your-github-username/django-ex/blob/master/welcome/templates/welcome/index.html` `line:214`<br /><br />**Commit** the change

      BEFORE:

             line 214: <h1>Welcome to your Django application on OpenShift</h1>

      AFTER:

             line 214: <h1>This is my first Django application on OpenShift</h1>


* This change should trigger a new build automatically<br /><br />Clicking on the **URL** should open the application, which is deployed with the changes you made
<br /><br />![Build-app-2](https://github.com/savithruml/openshift-contrail/blob/master/images/deploy-2.png)
<br /><br />![app-live-2](https://github.com/savithruml/openshift-contrail/blob/master/images/app-live-2.png)

# LAB 2 - Install Contrail/OpenShift on AWS

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
    
         Download from http://10.84.5.120/github-build/R4.0/20/ubuntu-14-04/mitaka/artifacts_extra/contrail-ansible-4.0.0.0-20.tar.gz

         Download from http://10.84.5.120/github-build/R4.0/20/ubuntu-14-04/mitaka/artifacts/contrail-kubernetes-docker-images_4.0.0.0-20.tgz


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
 
    Create a new project & move into the project context
    
         (master-node)# oc login -u system:admin
         (master-node)# oc new-project juniper 
         (master-node)# oc project juniper

    Create a service account to access the APIs
         
         (master-node)# oc create serviceaccount useroot
    
    Bind the service account to the role

         (master-node)# oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:juniper:useroot

    Add the user to a “privileged” security context constraint

         (master-node)# oadm policy add-scc-to-user privileged system:serviceaccount:juniper:useroot
         
    Assign cluster-admin role to admin user
    
         (master-node)# oadm policy add-cluster-role-to-user cluster-admin admin

    Get a token assigned to a service account
         
         (master-node)# oc serviceaccounts get-token useroot
         
    Copy this token. Login to "Contrail-kube-manager" container & paste this token
    
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
  
    Create a password for admin user to login to the UI
    
         (master-node)# htpasswd /etc/origin/master/htpasswd admin
         (master-node)# oc login -u admin
         
 
   
