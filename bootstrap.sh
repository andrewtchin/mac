#!/usr/bin/env bash
set -x

export HOMEBREW_NO_ANALYTICS=1

# Install xcode cli and homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Install Python"
brew install python@3.9

echo "Install Ansible"
sudo pip3 install ansible
