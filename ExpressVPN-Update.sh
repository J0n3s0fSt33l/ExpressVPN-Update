#! /bin/bash

#System update and cleanup.
apt update -y
apt dist-upgrade -yy
apt autoclean 
apt autoremove

#
MY_VERSION=$(expressvpn --version | awk '{print $3}' | awk -F '-' '{print $1}')

/usr/bin/curl -o xvp.txt --silent https://www.expressvpn.com/latest#linux || echo "Unable to connect to expressvpn.com. Check your network connection and try again"

CURRENT_VERSION=$(grep '_amd64.deb">Download' < xvp.txt | awk -F "_" '{print $2}' | awk -F "-" '{print $1}')

#Compare your current version of Expressvpn with the one listed on the website
if [[ "$MY_VERSION" == "$CURRENT_VERSION" ]]; then
	echo "ExpressVPN is up to date."
	
else

#Creates a variable for the download link
	DOWNLOAD=$(grep '_amd64.deb">Download' < xvp.txt | awk '{print $(NF)}' | awk -F '"' '{print $2}' )
#Creates a variable for the .deb file name
	DEB_FILE=$(echo "$DOWNLOAD" | awk -F '/' '{print $6}') 
#Creates a variable for the current version of Firefox
	FF_VERSION=$(sudo -u akali /usr/bin/firefox -v | awk '{print $3}' | awk -F '.' '{print $1}')
#Creates a variable for a user agent for use with wget
	USER_AGENT='Mozilla/5.0 (X11; Linux x86_64; rv:'$FF_VERSION".0) Gecko/20100101 Firefox/"$FF_VERSION.0
	
	echo "ExpressVPN is out of date. Updating now."
	echo "Downloading update file."
	/usr/bin/wget -q --user-agent "$USER_AGENT" "$DOWNLOAD" || echo "Unable to Download update file." 
	echo "Installing update"
	rm xvp.txt && dpkg -i "$DEB_FILE" || echo "Update installation NOT successful."
fi

read -rsp "Press any key to continue..."
