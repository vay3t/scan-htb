#!/bin/bash

target=$1

if [[ $(id -u) -ne 0 ]]; then
	echo "[!] Please run as root"
	exit 2
else
	if [ $# -ne 1 ];then
		echo "[*] Usage: bash $0 <target>"
		exit 1
	else
		if [[ $target =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
			masscan $target -p1-65535,U:1-65535 -oG scan.grep --rate=1000 -e tun0 &> /dev/null
			ports=$(grep open scan.grep | awk '{print $5}' | cut -d "/" -f1 | tr "\n" ",")
			nmap $target -p $ports -n -T4 -sC -sV -Pn
		else
			echo "[!] Invalid IP"
			exit 2
		fi
	fi
fi
