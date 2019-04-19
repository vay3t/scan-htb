#!/bin/bash

target=$1

portsTCP="Null"
portsUDP="Null"

if [[ $(id -u) -ne 0 ]]; then
	echo "[!] Please run as root"
	exit 2
else
	if [ $# -ne 1 ];then
		echo "[*] Usage: bash $0 <target>"
		exit 1
	else
		ifconfig tun0 &> /dev/null
		if [ $? -eq  0 ]; then
			if [[ $target =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
				echo "[+] Discovering ports..."
				masscan $target -p1-65535,U:1-65535 -oG out.grep --rate=1000 -e tun0 

				echo ""
				grep open out.grep | grep tcp > tmptcp.grep
				if [ $? -eq 0 ]; then
					portsTCP=$(cat tmptcp.grep | awk '{print $5}' | cut -d "/" -f1 | tr "\n" ",")
				fi

				grep open out.grep | grep udp > tmpudp.grep
				if [ $? -eq 0 ]; then
					portsUDP=$(cat tmpudp.grep | awk '{print $5}' | cut -d "/" -f1 | tr "\n" ",")
				fi

				if [ $portsTCP != "Null" ]; then
					echo "[+] Scan TCP ports"
					echo "nmap $target -p $portsTCP -n -T4 -sC -sV -Pn"
					nmap $target -p $portsTCP -n -T4 -sC -sV -Pn
				fi
				if [ $portsUDP != "Null" ]; then
					echo "[+] Scan UDP ports"
					echo "nmap $target -sU -p $portsUDP -n -T4 -sC -sV -Pn"
					nmap $target -sU -p $portsUDP -n -T4 -sC -sV -Pn
				fi
				echo "[*] Finished"
			else
				echo "[!] Invalid IP"
				exit 2
			fi
		else
			echo "[-] You are not connected to hackthebox"
		fi
	fi
fi
