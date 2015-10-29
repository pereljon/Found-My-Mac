#!/bin/bash
####
# Constants for mail SMTP server, port , user and password
SMTP_SERVER="MAIL.YOURSERVER.COM"
SMTP_PORT="465"
SMTP_USER="USERNAME"
SMTP_PASSWORD="PASSWORD"
# To and From in email
MAIL_TO="USER@YOURSERVER.COM"
MAIL_FROM="USER@YOURSERVER.COM"
###

# Macro for PlistBuddy
PLISTBUDDY="/usr/libexec/PlistBuddy -c"
# Location of clients.plist
CLIENTSFILE="/var/db/locationd/clients.plist"
# Unload Location Services daemon
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist 2> /dev/null
# Enable Location Services
uuid=$(/usr/sbin/system_profiler SPHardwareDataType 2> /dev/null | grep "Hardware UUID" | awk '{print $3}')
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd."$uuid" LocationServicesEnabled -int 1
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup."$uuid" LocationServicesEnabled -int 1
# Delete LocateMe entry in clients.plist
/usr/bin/defaults delete /var/db/locationd/clients.plist com.apple.locationd.executable-/usr/local/bin/LocateMe 2> /dev/null
# Add LocateMe entry in clients.plist
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Authorized bool 1" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:BundleId string com.apple.locationd.executable-/usr/local/bin/LocateMe" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Executable string /usr/local/bin/LocateMe" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Registered string /usr/local/bin/LocateMe" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Hide integer 0" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Whitelisted bool 0" "$CLIENTSFILE")
result=$($PLISTBUDDY "Add :com.apple.locationd.executable-/usr/local/bin/LocateMe:Requirement string cdhash H\\\"a210657900fb3f7f5bf0e1bc7d5934c2d1954242\\\" or cdhash H\\\"c8543eef385ebc910eadd05fa7a8071d6dd1cc64\\\"" "$CLIENTSFILE")
# Set ownership on locationd prefs
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd
# Load locationd
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist
# Get location in Google Maps format
LOCATION="$(/usr/local/bin/LocateMe -g)"
# Get computer name
COMPUTER_NAME="$(scutil --get ComputerName)"
# Take picture with iSight camera
/usr/local/bin/imagesnap -q /tmp/snapshot.jpg
# Send email with picture and GPS information
/usr/local/bin/mailsend -q -smtp "${SMTP_SERVER}" +cc -port ${SMTP_PORT} -auth -ssl -user "${SMTP_USER}" -pass "${SMTP_PASSWORD}" -t "${MAIL_TO}" -f "${MAIL_FROM}" -sub "Snapshot from ${COMPUTER_NAME}" -attach "/tmp/snapshot.jpg" -M "${LOCATION}"
# Delete picture from tmp directory
rm /tmp/snapshot.jpg

exit 0