#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall rulset

#alert tcp [2.57.234.0/23,2.58.148.0/22,5.42.199.0/24,5.134.128.0/19,5.183.60.0/22,5.188.10.0/23,24.137.16.0/20,24.170.208.0/20,24.233.0.0/19,24.236.0.0/19,27.123.208.0/22,27.126.160.0/20,27.146.0.0/16,31.24.81.0/24,31.41.244.0/24,31.217.252.0/24,31.222.236.0/24,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:3749; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2023_09_22;)


# Regex to extract the networks
# wget to download document
# Then egrep to do regex of each network within document
# 2.		  57.		      234.				0/		19

wget http://rules.emergingthreats.net/blockrules/emerging-drop.rules -O /tmp/emerging-drop.rules
#Checks to see if emerging threats file exists before download
# Filename variable
pFile=/tmp/emerging-drop.rules

#Checks to see if emerging threats file exists before download
if [[ -f "${pFile}" ]]
then
	# Prompt if we need to overwrite the file
	echo "The file ${pFile} already exists."
	echo -n "Do you want to overwrite it? [y|N]"
 	read to_overwrite

 	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n"  ]]
 	then
 		echo "Exiting..."
 		exit 0
 	elif [[ "${to_overwrite}" == "y" ]]
 	then
 		echo "Downloading Emerging Threats File..."
 	# If they don't specify y/N then error
    else
          echo "Invalid value"
          exit 1
 	fi
fi
# Parses IPs from emerging-drop.rules and puts it into badIPs.txt
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.rules | sort -u | tee badIPs.txt

# Create a firewall ruleset
function firewall()	{
	clear
	echo "How would you like the firewall ruleset to be made?"
	echo ""
	echo "[M]ac OS X"
	echo "[I]ptables"
	echo "[C]isco"
	echo "[W]indows"
 	echo "[P]arse Cisco Threats"
	read -p "Please enter a choice above: " choice

	case "$choice" in

			M|m)
			 # Adds Default Mac OS firewall ruleset to deault config file
			 echo '
			 scrub-anchor "com.apple/*"
			 nat-anchor "com.apple/*"
			 rdr-anchor "com.apple/*"
			 dummynet-anchor "com.apple/*"
			 anchor "com.apple/*"
			 load anchor "com.apple" from "/etc/pfanchors/com.apple"
			 ' | tee pf.conf

			 # MAC ruleset creation
			 for eachIP in $(cat badIPs.txt)
			 do
				 echo "block in from ${eachIP} to any" | tee -a pf.conf
			 done
			;;

			I|i)
			 # Creates Default iptables file
			 echo '
			 #iptables -A INPUT -s ipaddress - j DROP
			 ' | tee badIPs.iptables
			 
			 # Iptables ruleset creation
			 for eachIP in $(cat badIPs.txt)
			 do
				 echo "iptables -A INPUT -s ${eachIP} - j DROP" | tee -a badIPs.iptables
			 done
			;;
			C|c)
			 # Adds bad Ips to Cisco list
			 for eachIP in $(cat badIPs.txt)
			 do
			 	echo "deny ip host ${eachIP} any" | tee -a badIPs.cisco
			 done
			;;
			W|w)
			 # Adds bad IPs to a Windows Firewall Drop list
			 for eachIP in $(cat badIPs.txt)
			 do
			 	echo "netsh advfirewall firewall add rule name=\ "BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachIP}" | tee -a badIPs.netsh
			 done
			;;
			P|p)
			 # Gets targetedthreats, outputs it to targetedthreats.csv, and parses Cisco threats
			 wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
			 awk '/domain/ {print}' /tmp/targetedthreats.csv | awk -F \" '{print $4}' | sort -u > targetedthreats.txt
			 echo 'class-map match-any BAD_URLS' | tee ciscothreats.txt
			 for eachIP in $(cat targetedthreats.txt)
			 do
			 	echo "match protocol http host \"${eachIP}\"" | tee -a ciscothreats.txt
			 done
			;;
			*)

				echo ""
				echo "Nuh uh"
				echo ""
				sleep 2
			;;
	esac
}
firewall
