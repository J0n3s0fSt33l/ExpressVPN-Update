# ExpressVPN-Update

As of the time of the creation of this script, ExpressVPN doesn't have a way to automatically check for updates and install the newest version, so I wrote a handy little script to manage that.

This script was built on a Debian-based distro and assumes you have Firefox, cURL, and wget installed. 
The logic for this script is as follows:

-Run apt commands to update your system and clean old files

-Run curl and filter the html to identify the current version     listed on the website

-Compare the website version to yours

-If there's an update, a few variables are created to facilitate using the most updated version of Firefox as a user-agent (using wget without the user-agent yielded no success to me) making a wget request to https://www.expressvpn.com/latest#linux to download the update and automatically running dpkg -i on the file to update your system. 

## Please note: I have very little knowledge and skill in the way of scripting, so there are likely some less than preferred practices in here. This was built partly as a project to build a helpful tool, partly to practice using the curl and wget commands preparing for the eJPT.
