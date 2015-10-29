# Lost-My-Mac
Scripts to help you recover a lost mac computer. 

##LostMyMac.sh:
- Enables Mac OS Location Services.
- Authorizes LocateMe (wi-fi/GPS locator)
- Get current location of computer (requires AirPort interface to be active)
- Take picture using iSight camera.
- Send email through authenticated SMTP server with image attached and Google Maps GPS URL.

###Usage:
- Run script as root through a client management system (Casper's JAMF) when a computer is lost.
- Prior to run, make sure that the required software (below) is installed.

###Requires:
#####LocateMe:  A command-line utility to use OS X's geolocation service
- Download from: https://github.com/netj/LocateMe
- Install in: /usr/local/bin/LocateMe

#####mailsend: A program to send mail via SMTP from command line
- Download from: https://github.com/muquit/mailsend
- Install in: /usr/local/bin/mailsend

#####imagesnap: Capture Images from the Command Line
- Download from http://www.iharder.net/current/macosx/imagesnap/
- Install in: /usr/local/bin/imagesnap
