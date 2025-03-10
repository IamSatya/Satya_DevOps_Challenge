#!/bin/bash
apt-get update -y
apt-get install -y ansible
ufw allow 'Apache Full'
ansible-playbook  /tmp/ssl.yml
