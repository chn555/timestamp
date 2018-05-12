#!/bin/bash

# to get date -- date +%D
# to get hour -- date +%H:%M

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
  select Get_Status_Menu_Var in In Out; do
    case $Get_Status_Menu_Var in 
      "In")
        Current_Status="In" ;;

      "Out")
        Current_Status="Out" ;;
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
  sqlite3 ./timestamp.db "insert into stamps (id,date,time) values ('"$1"','"$2"','"$3"','"$4"');"
}

Display_Database () {
  sqlite3 ./timestamp.db "SELECT * FROM stamps"
}

Get_Time
Get_Date
Get_ID
Get_Status
Verify_Sqlite_exist
Verify_Database_Exist
Insert_To_Database $Current_ID $Current_Date $Current_Time  && echo "Timestamp successfully logged"
Display_Database
