#!/usr/bin/env bash
# written by David L. Whitehurst for CI Wise
#
# This script is sent over to a new Digital Ocean droplet called (DNS)
# ansible.ciwise.com and used to set-up a second droplet called (DNS)
# sandbox.ciwise.com with MySQL.
#

# Using APT install everything we need
apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get update -y
apt-get install ansible -y

cd /root
echo '[sandbox]' >> /etc/ansible/hosts
echo 'sandbox.ciwise.com' >> /etc/ansible/hosts

# next step to go to ansible.ciwise.com and ssh-keygen and copy
# id_rsa.pub to authorized_keys on sandbox.ciwise.com. Then you
# can run Ansible playbook that's already there.
