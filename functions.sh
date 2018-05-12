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

Get_Status () {
  PS3="Please select status (1,2) : "
  select Get_Status_Menu_Var in In Out; do
    case $Get_Status_Menu_Var in
      "In")
        Current_Status="In"
        return ;;
      "Out")
        Current_Status="Out"
        return ;;
    esac
  done
}

Verify_Sqlite_exist () {
  command -v sqlite3 &>/dev/null || yum install -y sqlite
}

Verify_Database_Exist () {
  Database_Exist_Var=$(sqlite3 ./timestamp.db "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type='table' AND name='stamps');")
  if [[ Database_Exist_Var -eq 1 ]]; then
    :
  elif [[ Database_Exist_Var -eq 0 ]]; then
    echo "Database does not exist, creating..."
    sqlite3 ./timestamp.db <<EOF
    create table stamps (id TEXT,date TEXT,time TEXT,status TEXT);
    select * from stamps;
EOF
  else
    echo "Something went wrong with the database, exiting."
    exit 1
  fi
}

Insert_To_Database () {
  sqlite3 ./timestamp.db "insert into stamps (id,date,time,status) values ('"$1"','"$2"','"$3"','"$4"');"
}

Display_Database () {
  sqlite3 ./timestamp.db "SELECT * FROM stamps"
}

Main () {
  if [[ -v Run_As_Root_Var ]]; then
    Distro_Check
    Get_Time && Get_Date && Get_ID && Get_Status
    Verify_Sqlite_exist && Verify_Database_Exist
    Insert_To_Database $Current_ID $Current_Date $Current_Time $Current_Status && echo "Timestamp successfully logged"
    Display_Database
  else
    Root_Check
    Distro_Check
    Get_Time && Get_Date && Get_ID && Get_Status
    Verify_Sqlite_exist && Verify_Database_Exist
    Insert_To_Database $Current_ID $Current_Date $Current_Time $Current_Status && echo "Timestamp successfully logged"
    Display_Database
  fi
}

Main
