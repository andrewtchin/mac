# macbook

## Usage

```bash
# Clone the repo
git clone git@github.com:andrewtchin/mac.git
cd mac

# Install XCode CLI, pip, and upstream Ansible, run provision.yml
./bootstrap.sh
```

## Running standalone playbook

```bash
source ansible/hacking/env-setup

# Provision
# This will provision MacOS, configure better defaults, and remove unused applications
ansible-playbook -vvv playbooks/provision.yml --ask-become-pass --extra-vars=@vars/config.yml

# Security
# This will configure extra security features of MacOS
ansible-playbook -vvv playbooks/security.yml --ask-become-pass
```

## Extras

* To configure *just* system defaults

```bash
ansible-playbook -vvv playbooks/defaults.yml --ask-become-pass --extra-vars=@vars/config.yml
```

## Notes

* MacOS hardening according to CIS. The security playbook will apply a custom configuration of security-related OS configuration.  Its core is based off of [CIS for macOS Sierra](https://github.com/jamfprofessionalservices/CIS-for-macOS-Sierra-CP).
