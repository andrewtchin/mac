#!/bin/bash

if [ -n "$COMPUTER_NAME" ]; then
echo ""
echo "Setting your computer name (as done via System Preferences >> Sharing)?  (y/n)"
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
fi

if [ -n "$LOCK_SCREEN_MESSAGE" ]; then
echo ""
echo "Setting lock screen message"
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$LOCK_SCREEN_MESSAGE"
fi