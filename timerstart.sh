#!/bin/bash

# to get date -- date +%D
# to get hour -- date +%H:%M


while getopts "r" opt; do
  case $opt in
    r)
      echo "This script can now be run as root, this is not recommended"
      Run_As_Root_Var=1
      ;;
    \?)
      echo "Invalid option, the only valid option right now is -r"
      exit 1
      ;;
  esac
done


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
    printf "Sorry, this script does not support your system \nit might still run, have fun trying \n"
	fi
}

Get_Time () {
  Current_Time=$(date +%H:%M)
}

Get_Date () {
  Current_Date=$(date +%d/%m/%y)
}

Get_ID () {
  Current_ID=$(echo $USER)
}

Save_Start_Time () {
  echo "Starting to count"
  declare -i Seconds
  while : ;do
    sleep 1s
    Seconds=$(( $Seconds + 1  ))
    echo "$Seconds $Current_Time $Current_Date" > $Current_ID.txt
  done
}




Main () {
  if [[ Run_As_Root_Var -eq 1 ]]; then
    Distro_Check
    Get_Time && Get_Date && Get_ID
    Save_Start_Time
  else
    Root_Check
    Distro_Check
    Get_Time && Get_Date && Get_ID
    Save_Start_Time
  fi
}

Main
