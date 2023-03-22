#!/bin/bash

cecho(){
	Black='\033[0;30m'        # Black
	Red='\033[0;31m'          # Red
	Green='\033[0;32m'        # Green
	Yellow='\033[0;33m'       # Yellow
	Blue='\033[0;34m'         # Blue
	Purple='\033[0;35m'       # Purple
	Cyan='\033[0;36m'         # Cyan
	White='\033[0;97m'        # White

    NC="\033[0m" # No Color

    # printf "${(P)1}${2} ${NC}\n" # <-- zsh
    printf "${!1}${2} ${NC}\n" # <-- bash
}


cecho "White" "INSE6110 Project Tool started... \n"
cecho "White" "Analyzing all interfaces that Wireshark has access to..."

powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe -D'

searchString="LAN-Verbindung.*$1"
cecho "White" "\n Filtering for corresponding Hotspot interface (LAN-Verbindung* $1) ...:" 
powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe -D' | grep "$searchString"

cecho "White" "\n Corresponding Wireshark ID found: "
powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe -D' | grep "$searchString"  | cut -d. -f1
wiresharkID=$(powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe -D' | grep "$searchString"  | cut -d. -f1)

cecho "White" "\n Finding current IP addresses ...:"
powershell.exe ipconfig

cecho "White" "\n Filtering out relevant entry and respective IPv4 address..."
powershell.exe ipconfig | grep "$searchString" -A 10000 | grep -m1 -F "IPv4-Adresse  . . . . . . . . . . :"
wiresharkIP=$(powershell.exe ipconfig | grep "$searchString" -A 10000 | grep -m1 -F "IPv4-Adresse  . . . . . . . . . . :" | cut -d: -f2)
echo $wiresharkIP
cecho "White" "\n Create log file for captured pcaps...:"
date=$(date +%F_%H-%M-%S)
log="$date.pcap"
echo $log

cecho "White" "\n Starting Capturing of Traffic at Wireshark ...:"
cecho "White" "\n Capturing Time set to 20 seconds...:"
# Create the command to be executed in powershell.exe
cmd="C:\Program Files\Wireshark\tshark.exe" # -i ${wiresharkID}
echo $cmd

# Execute the command in powershell.exe
powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe' -a duration:20 -w ./captures/${log} -i ${wiresharkID} host ${wiresharkIP} 
#needs to be in ./logs/ for generate_result_summary.py

cecho "White" "\n Ended Capture."
