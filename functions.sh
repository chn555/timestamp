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
  until [[ $Current_ID =~ [0-9]{1,3} ]]; do
    echo "Invalid ID, try again "
    read -p "Please enter your 3 digit ID : " Current_ID
  done
}

Verify_Sqlite_exist () {
  command -v sqlite3 || yum install -y sqlite
}

Verify_Database_Exist () {
  Database_Exist_Var=$(sqlite3 ./timestamp.db "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type='table' AND name='stamps');")
  if [[ Database_Exist_Var -eq 1 ]]; then
    echo "Database exists, moving on"
  elif [[ Database_Exist_Var -eq 0 ]]; then
    echo "Database does not exist, creating..."
    sqlite3 ./timestamp.db <<EOF
    create table stamps (id INTEGER,date TEXT,time TEXT);
    insert into stamps (id, date, time) values ('001','12/09/17', '00:00');
    select * from stamps;
EOF
  fi
}



Get_Time
Get_Date
Get_ID

printf "%s\n" $Current_Time $Current_Date $Current_ID

Verify_Sqlite_exist
Verify_Database_Exist
