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

Get_Time
Get_Date
Get_ID

printf "%s\n" $Current_Time $Current_Date $Current_ID
