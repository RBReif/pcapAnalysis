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


cecho "White" "INSE6110 Project Tool started for $3 ... \n"
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
log="$date-$3.pcap"
echo $log

cecho "White" "\n Starting Capturing of Traffic at Wireshark ...:"
cecho "White" "\n Capturing Time set to $2 seconds...:"
# Create the command to be executed in powershell.exe
cmd="C:\Program Files\Wireshark\tshark.exe" # -i ${wiresharkID}
echo $cmd

# Execute the command in powershell.exe
powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe' -a duration:$2 -w ./logs/${log} -i ${wiresharkID} host ${wiresharkIP} 

cecho "White" "\n Ended Capture without Proxy."
cecho "White" "\n Now start Proxy on Android. Confirm"
read 

cecho "White" "\n Starting second Capture with Proxy."
cecho "White" "\n Create log file for captured pcaps...:"
date=$(date +%F_%H-%M-%S)
log="$date-$3-MitM.pcap"
echo $log

cecho "White" "\n Starting Capturing of Traffic at Wireshark ...:"
cecho "White" "\n Capturing Time set to $2 seconds...:"
# Create the command to be executed in powershell.exe
cmd="C:\Program Files\Wireshark\tshark.exe" # -i ${wiresharkID}
echo $cmd

# Execute the command in powershell.exe
powershell.exe 'C:\"Program Files"\"Wireshark"\tshark.exe' -a duration:$2 -w ./logs/${log} -i ${wiresharkID} host ${wiresharkIP} &

cecho "White" "\n Task moved to background ..."
date=$(date +%F_%H-%M-%S)
logM="$date-$3-MitM.log"
echo $logM

cecho "White" "\n Starting Man-in-the-Middle Proxy. Starting dumping ..."
( powershell.exe "mitmdump" > $logM  ) & sleep $2 ; powershell.exe "Stop-Process -Name mitmdump"

sleep 3
wait 

cecho "White" "\n Finished second capture..."
cecho "White" "\n Starting analyizing..."

cecho "White" "\n Analyzing for first party certificate pinning for $3:...\n"
if grep "Client TLS handshake failed." $logM | grep $3 ; then
cecho "Cyan" "\n\n First Party Certificate Pinning detected for $3 \n\n"
else 
cecho "Purple" "\n\n NO First Party Certificate Pinning detected for $3 \n\n"
fi

cecho "White" "\n Analyzing for third party certificate pinning for $3:... \n"
if grep "Client TLS handshake failed." $logM | grep -v $3 ; then
cecho "Cyan" "\n\n Third Party Certificate Pinning detected for $3 \n\n"
else 
cecho "Purple" "\n\n NO First Party Certificate Pinning detected for $3 \n\n"
fi

cecho "White" "\n Starting scripts from original paper for  $3:... \n"
cecho "Red" "\n Fill in what Syed and Irwin did here: ... \n"

