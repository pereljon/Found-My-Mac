#!/bin/bash
PLISTBUDDY="/usr/libexec/PlistBuddy -c"
CLIENTSFILE="/var/db/locationd/clients.plist"
# Unload locationd
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist 2> /dev/null
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
exit 0