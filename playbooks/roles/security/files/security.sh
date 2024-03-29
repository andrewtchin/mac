# collected from various parts of the web
# some here: github.com/jamfprofessionalservices, some here: https://github.com/mathiasbynens/dotfiles

currentUser="$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"

# enable auto update
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# enable app auto update
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# enable system data files and security update installs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -bool true
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# enable set time and date automatically
sudo systemsetup -setusingnetworktime on

# enable screensaver after 10 minutes of inactivity
defaults write /Users/"$currentUser"/Library/Preferences/ByHost/com.apple.screensaver."$hardwareUUID".plist idleTime -int 600

#
# OS Security
#

# disable remote apple events
sudo systemsetup -setremoteappleevents off

# disable internet sharing
# /usr/libexec/PlistBuddy -c "Delete :NAT:AirPort:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
# /usr/libexec/PlistBuddy -c "Add :NAT:AirPort:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist
# /usr/libexec/PlistBuddy -c "Delete :NAT:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
# /usr/libexec/PlistBuddy -c "Add :NAT:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist
# /usr/libexec/PlistBuddy -c "Delete :NAT:PrimaryInterface:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
# /usr/libexec/PlistBuddy -c "Add :NAT:PrimaryInterface:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist

# disable screen sharing and remote management
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -access -off
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# disable print sharing
/usr/sbin/cupsctl --no-share-printers
/usr/sbin/cupsctl --no-remote-admin
/usr/sbin/cupsctl --no-remote-any

# disable remote login
sudo systemsetup -f -setremotelogin off

# disable bluetooth sharing
/usr/libexec/PlistBuddy -c "Delete :PrefKeyServicesEnabled"  /Users/"$currentUser"/Library/Preferences/ByHost/com.apple.Bluetooth."$hardwareUUID".plist
/usr/libexec/PlistBuddy -c "Add :PrefKeyServicesEnabled bool false"  /Users/"$currentUser"/Library/Preferences/ByHost/com.apple.Bluetooth."$hardwareUUID".plist

# don't wake for network access
sudo pmset -a womp 0

# enable gatekeeper
sudo spctl --master-enable

# enable firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2

# enable firewall stealth mode (don't respond to ping, etc)
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# enable logging
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

# Disabled allow signed built-in applications automatically
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Disabled allow signed downloaded applications automatically
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# restart firewall
sudo pkill -HUP socketfilterfw

# disable bonjour advertising service
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

# ensure nfs server is not running
sudo nfsd stop
sudo nfsd disable

#find /System -type d -perm -2 # secure home folders
# IFS=$'\n'
# for userDirs in $( find /Users -mindepth 1 -maxdepth 1 -type d -perm -1 | grep -v "Shared" | grep -v "Guest" ); do
#     chmod -R og-rwx "$userDirs"
# done
# unset IFS
# 
# # make sure system wide apps have appropriate permissions
# IFS=$'\n'
# for apps in $( find /Applications -iname "*\.app" -type d -perm -2 ); do
#     chmod -R o-w "$apps"
# done
# unset IFS
# 
# # check for world writeable files in /System
# IFS=$'\n'
# for sysPermissions in $( find /System -type d -perm -2 ); do
#     chmod -R o-w "$sysPermissions"
# done
# unset IFS

# automatically lock login keychain for inactivity
# security set-keychain-settings -u -t 21600s /Users/"$currentUser"/Library/Keychains/login.keychain

# lock the login keychain when computer sleeps
# security set-keychain-settings -l /Users/"$currentUser"/Library/Keychains/login.keychain

# enable OCSP and CRL certificate checking
defaults write com.apple.security.revocation OCSPStyle -string RequireIfPresent
defaults write com.apple.security.revocation CRLStyle -string RequireIfPresent
defaults write /Users/"$currentUser"/Library/Preferences/com.apple.security.revocation OCSPStyle -string RequireIfPresent
defaults write /Users/"$currentUser"/Library/Preferences/com.apple.security.revocation CRLStyle -string RequireIfPresent

# don't enable the 'root' account
sudo dscl . -create /Users/root UserShell /usr/bin/false

# password on wake from sleep or screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# require admin password to access system-wide preferences
sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
/usr/libexec/PlistBuddy -c "Set :shared false" /tmp/system.preferences.plist
sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist

# disable ability to login to another user's active and locked session
sudo security authorizationdb write system.login.screensaver "use-login-window-ui"

# disable fast user switching
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false

# login window as name and password (not prompted for with a username)
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# disable guest account
sudo defaults write /Library/Preferences/com.apple.loginwindow.plist GuestEnabled -bool false

# disable allow guests to connect to shared folders
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool no
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool no

# remove guest home folder
rm -rf /Users/Guest

# turn on filename extensions
sudo -u "$currentUser" defaults write NSGlobalDomain AppleShowAllExtensions -bool true
pkill -u "$currentUser" Finder

# disable automatic run of safe files in Safari
defaults write /Users/"$currentUser"/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false

# reduce sudo timeout period
echo "Defaults timestamp_timeout=2" | sudo tee -a /etc/sudoers

