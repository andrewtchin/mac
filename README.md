# macbook

## Before

- Backup existing files if reinstalling a currently used mac
- Remove all external storage
- Enter macOS recover to erase HD https://support.apple.com/en-us/HT208496
- Reset NVRAM https://support.apple.com/en-us/HT204063
- Run Internet Recovery https://support.apple.com/en-us/HT204904
- Set firmware password https://support.apple.com/en-au/HT204455

## Usage

### One touch
```bash
# Work playbook
curl -L https://raw.githubusercontent.com/andrewtchin/mac/master/bootstrap-work.sh | bash

# Home playbook
curl -L https://raw.githubusercontent.com/andrewtchin/mac/master/bootstrap-home.sh | bash
```

### Manually
```bash
# Clone the repo
git clone git@github.com:andrewtchin/mac.git
cd mac

# Run additional playbooks
./bootstrap-work.sh
./bootstrap-home.sh
```

### Required post install steps
```
# Install dotfiles
chsh -s /bin/zsh
curl -L https://raw.githubusercontent.com/andrewtchin/ansible-common/master/dotfiles.sh | bash

# Setup Gas Mask
https://github.com/StevenBlack/hosts
http://sbc.io/hosts/hosts

# Check config
https://github.com/kristovatlas/osx-config-check

# Configure Little Snitch

# Remap ESC

# Require password immediately after screensaaver
# Show a lock message
```

#### Firefox settings

- `about:preferences#privacy`
  - Enable `Clear history when Firefox closes`
  - Enable `Delete cookies and site data when Firefox is closed`
  - Disable Address bar suggestions from `Browsing history`
  - Disable `Autofill addresses`
  - Disable `Ask to save logins and passwords for websites`
  - Disable data sharing
  - Set `Enhanced Tracking Protection` `Strict`
- Edit `about:config` `network.http.sendRefererHeader`
  - 0 = never send the header

#### Visual Studio Code Plugins

- Java
  - checkstyle
  - java
  - lombok
- Python
  - pylint
- Terraform

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

Follow post install steps

## Defaults only

```bash
ansible-playbook -vvv playbooks/defaults.yml --ask-become-pass --extra-vars=@vars/config.yml
```

## Security

MacOS hardening according to CIS. The security playbook will apply a custom configuration of security-related OS configuration.

Its core is based off of [CIS for macOS Sierra](https://github.com/jamfprofessionalservices/CIS-for-macOS-Sierra-CP).

```bash
ansible-playbook -vvv playbooks/security.yml --ask-become-pass
```
