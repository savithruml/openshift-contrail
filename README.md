# RedHat Openshift Origin with Juiper Contrail Networking

# INSTALL DEPENDENCIES

./master-1.sh

    yum install kernel-devel kernel-headers git epel-release -y
    yum install "ansible @Development Tools" python2-pip openssl-devel python-devel -y
    sed -i s/SELINUX=permissive/SELINUX=enforcing/g /etc/selinux/config
    reboot

./slave-1.sh

    yum install kernel-devel kernel-headers nfs-utils socat epel-release -y
    sed -i s/SELINUX=permissive/SELINUX=enforcing/g /etc/selinux/config
    reboot

# INSTALL OPENSHIFT

./master-2.sh

    ssh-keygen –t rsa
    ssh-copy-id root@master
    ssh-copy-id root@slave

    cd ~/root
    git clone https://github.com/savithruml/openshift-contrail
    git clone https://github.com/openshift/openshift-ansible

    yes | cp ~/root/openshift-contrail/openshift/install-files/ose-install openshift-ansible/inventory/byo/
    yes | cp ~/root/openshift-contrail/openshift/install-files/ose-prerequisites.yml openshift-ansible/inventory/byo/

    cd ~/root/openshift-ansible
    ansible-playbook -i inventory/byo/ose-install playbooks/byo/openshift_facts.yml
    ansible-playbook -i inventory/byo/ose-install playbooks/byo/config.yml

# INSTALL CONTRAIL

./master-3.sh

    cd ~/root
    mkdir contrail-ansible && cd contrail-ansible
    wget http://10.84.5.120/github-build/R4.0/20/ubuntu-14-04/mitaka/artifacts_extra/contrail-ansible-4.0.0.0-20.tar.gz
    tar -xvzf contrail-ansible-4.0.0.0-20.tar.gz
    yes | cp ~/openshift-contrail/contrail/install-files/all.yml playbooks/inventory/my-inventory/group_vars/
    yes | cp ~/openshift-contrail/contrail/install-files/hosts playbooks/inventory/my-inventory/

    ansible-playbook -i inventory/my-inventory site.yml
