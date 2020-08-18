#!/usr/bin/env bash

export HOMEBREW_NO_ANALYTICS=1

# Install xcode cli and homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Install Python"
brew install python@3.8

echo "Install Ansible"
sudo pip3 install ansible

git clone https://github.com/andrewtchin/mac.git
cd mac

ansible-playbook -vvv playbooks/work.yml --ask-become-pass --extra-vars=@vars/config.yml