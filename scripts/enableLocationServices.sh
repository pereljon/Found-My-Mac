#!/bin/bash
# Enable location services
uuid=$(/usr/sbin/system_profiler SPHardwareDataType 2> /dev/null | grep "Hardware UUID" | awk '{print $3}')
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist 2> /dev/null
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd."$uuid" LocationServicesEnabled -int 1
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup."$uuid" LocationServicesEnabled -int 1
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist
exit 0