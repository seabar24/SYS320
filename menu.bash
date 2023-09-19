#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {

	echo ""
	echo "Nuh uh"
	echo  ""
	sleep 2

}


function menu() {

	# clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		1) admin_menu
		;;

		2) security_menu
		;;

		3) exit 1

		;;
		*)

			invalid_opt
			# Call the main menu
			menu

		;;
	esac

}

function admin_menu {

	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l) ps -ef| less
		;;
		N|n) netstat -an --inet| less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
		;;

	esac

admin_menu
}

function vpn_menu() {

	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		A|a)
		# Adds a peer
		 bash peer.bash
		 tail -6 /etc/wireguard/wg0.conf | less

		;;
		D|d)
		# Deletes a peer by checking server config file.
		 read -p "Name the user you want to delete: " user

		 if  grep -q "# $user" /etc/wireguard/wg0.conf ; then

			echo ""
			echo "Deleting User..."
			sudo sed -i "/# $user begin/,/# $user end/d" /etc/wireguard/wg0.conf
			echo ""
			sleep 2

		else

			echo ""
			echo "User '$user' does not exist."
			echo ""
			sleep 2

		 fi
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 1
		;;
		*)
			invalid_opt

		;;

	esac
vpn_menu
}
# Menu that has secure information on users and network.
function security_menu() {

	clear
	echo "[L]ist Open Network Sockets"
	echo "[C]heck Users"
 	echo "[B]ack to Menu"
	echo "[E]xit Program"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l)
		# Checks for open socket on network.
		netstat -tuln |less
  		sleep 6
		;;
		C|c)
		 users_menu
		;;
  		B|b)
    		 menu
       		;;
		E|e)
			exit 1
		;;
		*)

	 		invalid_opt
	 	;;

	esac
security_menu
}
# Menu that checks User information.
function users_menu() {

	clear
	echo "[I]D of User"
 	echo "[U]ser in wg0.conf"
	echo "[L]ast Logged in Users"
	echo "[C]urrently logged in User"
	echo "[E]xit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		I|i)
		# Checks if User ID is 0 or not.
		 read -p "What user do you want to check? " user
   
   		 if  grep -q "$user" /etc/passwd ; then

		 	if  grep "$user" /etc/passwd | cut -d: -f3 == 0  ; then

		 		echo ""
		 		echo "User $user has a UID of 0."
		 		echo ""
		 		sleep 2

		 	else

		 		echo ""
		 		echo "User $user does NOT have a UID of 0."
		 		echo ""
     			fi
     		 else
		 	echo "User $user does NOT exist."
	 		sleep 4
		 fi
		;;
  		U|u)
    		 read -p "Name the user you want to check: " user
    		 if  grep -q "# $user" /etc/wireguard/wg0.conf ; then
       			echo "User $user does exist."
	  		sleep 4
	  	 else
     		 	echo "User $user does NOT exist."
	 		sleep 4
	 	 fi
    		;;
		L|l)
		# Checks the last 10 users that were logged in.
		 last | head -n 10
		 sleep 5
		;;
		C|c)
		# Checks currently logged in user
		 whoami
		 sleep 5
		;;
		E|e) exit 1
		;;
		*)

			invalid_opt

		;;
	esac
users_menu

}

# Call the main function
menu
