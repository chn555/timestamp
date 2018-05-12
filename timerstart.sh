#!/bin/bash

# to get date -- date +%D
# to get hour -- date +%H:%M

Script_Options () {
  while getopts "r" opt; do
    case $opt in
      r)
        echo "This script can now be run as root, this is not recommended"
        Run_As_Root_Var="1"
        ;;
      \?)
        echo "Invalid option, the only valid option right now is -r"
        exit 1
        ;;
      esac
    done
}

Root_Check () {		## checks that the script runs as root
	if [[ $EUID -ne 0 ]]; then
		:
	else
		printf "$line\n"
		printf "The script cannot be run with root privileges\n"
		printf "$line\n"
		exit 1
	fi
}

Distro_Check () {		## checking the environment the user is currenttly running on to determine which settings should be applied
	cat /etc/*-release |grep ID |cut  -d "=" -f "2" |egrep "^arch$|^manjaro$" &> /dev/null

	if [[ $? -eq 0 ]]; then
	  	Distro_Val="arch"
	else
	  	:
	fi

  cat /etc/*-release |grep ID |cut  -d "=" -f "2" |egrep "^debian$|^\"Ubuntu\"$" &> /dev/null

  if [[ $? -eq 0 ]]; then
    	Distro_Val="debian"
  else
    	:
  fi

	cat /etc/*-release |grep ID |cut  -d "=" -f "2" |egrep "^\"centos\"$|^\"fedora\"$" &> /dev/null

	if [[ $? -eq 0 ]]; then
	   	Distro_Val="centos"
	else
		:
	fi

	if ! [[ $Distro_Val == "centos" ]]; then
		printf "Sorry, this script does not support your system"
	fi
}

Get_Time () {
  Current_Time=$(date +%H:%M)
}

Get_Date () {
  Current_Date=$(date +%d/%m/%y)
}

Get_ID () {
  read -p "Please enter your 3 digit ID : " Current_ID
  until [[ $Current_ID =~ [0-9]{3} ]]; do
    echo "Invalid ID, try again "
    read -p "Please enter your 3 digit ID : " Current_ID
  done
}

Save_Start_Time () {
  echo $Current_Time.$Current_Date > $Current_ID.txt
}




Main () {
  Script_Options
  if [[ -v Run_As_Root_Var ]]; then
    Distro_Check
    Get_Time && Get_Date && Get_ID && Get_Status
  else
    Root_Check
    Distro_Check
    Get_Time && Get_Date && Get_ID && Get_Status
  fi
}

Main
