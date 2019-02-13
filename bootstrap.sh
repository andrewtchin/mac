#!/usr/bin/env bash

# Install xcode cli
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Ansible
sudo easy_install pip

git clone https://github.com/ansible/ansible.git --recursive
source ansible/hacking/env-setup
pip install --user -r ansible/requirements.txt

# Run playbook
ansible-playbook -vvv playbooks/provision.yml --ask-become-pass --extra-vars=@vars/config.yml
