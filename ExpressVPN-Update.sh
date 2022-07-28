#!/bin/bash

#System update and cleanup.
apt update -y
apt dist-upgrade -y
apt autoclean 
apt autoremove

my_ver=$(expressvpn --version | awk '{print $3}' | awk -F '-' '{print $1}')

/usr/bin/curl -o xvp.txt --silent 'https://www.expressvpn.com/latest#linux' || echo "Unable to connect to expressvpn.com. Check your network connection and try again"

current_ver=$(grep '_amd64.deb">Download' < xvp.txt | awk -F "_" '{print $2}' | awk -F "-" '{print $1}')

#Compare your current version of Expressvpn with the one listed on the website
if [[ "$my_ver" == "$current_ver" ]]; then
	echo "ExpressVPN is up to date."	
else

#Creates a variable for the download link
	download=$(grep '_amd64.deb">Download' < xvp.txt | awk '{print $(NF)}' | awk -F '"' '{print $2}' )
#Creates a variable for the .deb file name
	deb_file=$(echo "$download" | awk -F '/' '{print $6}') 
#Creates a variable for the current version of Firefox
	ff_ver=$(sudo -u akali /usr/bin/firefox -v | awk '{print $3}' | awk -F '.' '{print $1}')
#Creates a variable for a user agent for use with wget
	user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:'$ff_ver".0) Gecko/20100101 Firefox/"$ff_ver.0
	echo "ExpressVPN is out of date. Updating now."
	echo "Downloading update file."
	/usr/bin/wget -q --user-agent "$user_agent" "$download" || echo "Unable to download update file." 
	echo "Installing update"
	rm xvp.txt && dpkg -i "$deb_file" || echo "Update installation NOT successful."
fi

read -rsp "Press any key to continue..."
