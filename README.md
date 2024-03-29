# mac

This will provision macOS, configure better defaults, and remove unused applications

## Before

- Backup existing files if reinstalling a currently used mac
- Remove all external storage
- Enter macOS recover to erase HD https://support.apple.com/en-us/HT208496
- Reset NVRAM https://support.apple.com/en-us/HT204063
- Run Internet Recovery https://support.apple.com/en-us/HT204904
- Set firmware password (`sudo firmwarepasswd -setpasswd` and `sudo firmwarepasswd -check`) https://support.apple.com/en-us/HT204455
- Give Terminal Full Disk Access: System Preferences, Security & Privacy, Privacy, Full Disk Access

## Usage

### Bootstrap and run
```bash
curl -Lo bootstrap.sh https://raw.githubusercontent.com/andrewtchin/mac/master/bootstrap.sh
bash bootstrap.sh

git clone https://github.com/andrewtchin/mac.git
cd mac

# Pick which playbook
export MAC_HOSTNAME=
export MAC_LOCKSCREEN=
ansible-playbook -vvv playbooks/home.yml --ask-become-pass --extra-vars=@vars/config.yml
ansible-playbook -vvv playbooks/work.yml --ask-become-pass --extra-vars=@vars/config.yml

# Security
ansible-playbook -vvv playbooks/security.yml --ask-become-pass
```

### Required post install steps
```
# Install dotfiles
curl -L https://raw.githubusercontent.com/andrewtchin/ansible-common/master/dotfiles.sh | bash
```

- Setup nextdns
- Configure Little Snitch
- Remap ESC
- Require password immediately after screensaver

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


## Set Defaults

Runs `system-config` role

```bash
ansible-playbook -vvv playbooks/defaults.yml --ask-become-pass --extra-vars=@vars/config.yml

or

ansible-playbook -vvv playbooks/home.yml --ask-become-pass --extra-vars=@vars/config.yml --start-at-task="Set OS X defaults"
```

## Security

MacOS hardening according to CIS. The security playbook will apply a custom configuration of security-related OS configuration.

Its core is based off of [CIS for macOS Sierra](https://github.com/jamfprofessionalservices/CIS-for-macOS-Sierra-CP).
