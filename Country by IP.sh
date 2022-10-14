#!/bin/bash

: HEADER = <<'EOL'

██████╗  ██████╗  ██████╗██╗  ██╗███████╗████████╗███╗   ███╗ █████╗ ███╗   ██╗
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝╚══██╔══╝████╗ ████║██╔══██╗████╗  ██║
██████╔╝██║   ██║██║     █████╔╝ █████╗     ██║   ██╔████╔██║███████║██╔██╗ ██║
██╔══██╗██║   ██║██║     ██╔═██╗ ██╔══╝     ██║   ██║╚██╔╝██║██╔══██║██║╚██╗██║
██║  ██║╚██████╔╝╚██████╗██║  ██╗███████╗   ██║   ██║ ╚═╝ ██║██║  ██║██║ ╚████║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝

        Name: Country by IP Address
 Description: Uses the Mac's external IP Address to determine which country it is in. Deployed as an Extension Attribute through Jamf Pro.
  Parameters: $1-$3 - Reserved by Jamf (Mount Point, Computer Name, Username)

  Created By: Chris Schasse
     Version: 1.0
     License: Copyright (c) 2022, Rocketman Management LLC. All rights reserved. Distributed under MIT License.
   More Info: For Documentation, Instructions and Latest Version, visit https://www.rocketman.tech/jamf-toolkit

  Directions: To use this extension attribute, enter the base64 encoded 'USERNAME:PASSWORD' of an API user with READ privileges on the COMPUTERS object into the variable below.
EOL

##
## Variables to Assign
##

## Enter the Base64 encoded "USER:PASSWORD" string for the API user
APIHASH=''

##
## System Variables
##

JAMFURL=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url)
SERIAL=$(system_profiler SPHardwareDataType | grep "Serial Number" | awk -F': ' '{print $NF}')

##
## SCRIPT CONTENTS, DO NOT MODIFY BELOW THESE LINES (Unless you know what you're doing)
##

## API Configuration
IP_ADDRESS=$(curl -sk -H "Authorization: Basic ${APIHASH}" ${JAMFURL}/JSSResource/computers/serialnumber/${SERIAL} | xmllint --xpath '/computer/general/ip_address/text()' -)

if [[ $IP_ADDRESS ]]; then
  ## Geolocation based on IP Address in Jamf
  GEODATA=$(curl -s -H "User-Agent: keycdn-tools:${JAMFURL}" "https://tools.keycdn.com/geo.json?host=${IP_ADDRESS}" 2>&1)  

  ## Get country from the Geolocation
  COUNTRY=$(echo ${GEODATA} | plutil -extract "data"."geo"."country_name" raw -o - -)
else
  RESULT="ERROR - IP Address lookup failed"
fi

## If data exists show the country, otherwise come back with an error
if [[ ${COUNTRY} ]]; then
	RESULT=${COUNTRY}
fi

echo "<result>${RESULT}</result>"