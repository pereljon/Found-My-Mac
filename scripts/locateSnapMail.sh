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