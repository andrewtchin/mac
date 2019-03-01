#!/usr/bin/env bash

export HOMEBREW_NO_ANALYTICS=1

VMWARE=""

while [ $# -gt 0 ]; do
  key="$1"

  case $key in
    --vmware)
      VMWARE="1"
      echo "Running VMware playbook"
      ;;
  esac
  shift # past argument or value
done

# Install xcode cli
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Ansible
sudo easy_install pip

git clone https://github.com/ansible/ansible.git --recursive
source ansible/hacking/env-setup
pip install --user -r ansible/requirements.txt

# Run playbook
ansible-playbook -vvv playbooks/provision.yml --ask-become-pass --extra-vars=@vars/config.yml

if [ -n "$VMWARE" ]; then
  ansible-playbook -vvv playbooks/vmware.yml --ask-become-pass
fi
