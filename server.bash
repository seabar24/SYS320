# if statem,ent that checks if "wg0.conf" exists.
file=/etc/wireguard/wg0.conf
#!/bin/bash
# Storyline: Script to create a wireguard server
# Create a private key
p="$(wg genkey)"
echo "${p}" > /etc/wireguard/server_private.key
# Create a public key
pub="$(echo ${p} | wg pubkey)"
echo "${pub}" > /etc/wireguard/server_public.key
# Set the addresses
address="10.254.132.0/24"
# Set Server IP Addresses
ServerAddress="10.254.132.1/24"
# Set a listening port
lport="4282"
# Info to be used in client configuration
peerInfo="# ${address} 192.168.241.131:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"
# 1: #, 2: For obtaining an IP address for each client.
# 3: Server's actual IP address
# 4: clients will need server public key
# 5: dns information
# 6: determines the largest packet size allowed
# 7: keeping connection alive for
# 8: what traffic to be routed through VPN
if [ -f "$file" ]; then
	echo '"$file" does exist'
	read "Do you wish to Override? (Y/N)"choice
	if [ "$choice" == "Y" ]; then
		echo "${peerInfo}
		[Interface]
		Address = ${ServerAddress}
		PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
		PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens33 -j MASQUERADE
		ListenPort = ${lport}
		PrivateKey = ${p}
		" > /etc/wireguard/wg0.conf;
	if [ "$choice" == "N" ]; then
		echo "Exiting the Program"
		exit 1;
	fi
else
	echo "${peerInfo}
	[Interface]
	Address = ${ServerAddress}
    PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
	PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens33 -j MASQUERADE
	ListenPort = ${lport}
	PrivateKey = ${p}
	" > /etc/wireguard/wg0.conf;
fi
