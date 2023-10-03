#!/bin/bash

#Parse Apache log
#101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "GET / HTTP/1.1" 200 205 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"

#Read in file

#Checks to see if Apache File exists.
read -p "Please enter an apache log file: " tFile
#check if file exists
if [[ ! -f ${tFile}  ]]
then
	echo -e "\e[1;31mWRONG. WRONG. WRONG.\e[0m"
	exit 1
fi

# Parses Apache File and outputs it to badIPSTables file
sed -e "s/\[//g" -e "s/\"//g" ${tFile} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-8s %-1s %-5s %-1s %-10s %-3s %s\n"}
{printf format, "iptables", "-A", "INPUT", "-s", $1, "-j", "REJECT" }' > badIPSTables

#Removes duplicate IP Addresses
#(Don't ask me why I had to make a tmp and then back into the same file. It wouldn't work otherwise.)
sort -t' ' -k5,5 -u -o badIPSTables badIPSTables
