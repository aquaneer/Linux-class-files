#!/bin/bash

#Date: 06/18/2014
#Version: 1
#Creator: Neer Shrestha 

source /root/bin/library.sh

trap cleanup SIGINT SIGTERM EXIT

PS3="Please select an option from the choices above: "

select CHOICE in "Show IP Address" "Show Disk Usage of all users" "Show Disk Usage by a user" "Show Large Files by a user" "Show how many Web Pages accessed by IP" "Copy files" "Quit"
do
    case $CHOICE in 
         "Show IP Address")                        fn_eth0_IPaddress
                                                   break ;;
         "Show Disk Usage of all users")           fn_combined_userhomedir
                                                   break ;;
         "Show Disk Usage by a user")              fn_each_userhomedir
                                                   break ;;
         "Show Large Files by a user")             fn_show_largerfiles 
                                                   break ;;    
         "Show how many Web Pages accessed by IP") fn_webpagerequest_IP
                                                   break ;;
         "Copy files")                             fn_copy_files
                                                   break ;;
         "Quit")                                   exit ;;
         *)                                        echo "Sorry, wrong selection. Please select again from the 7 options." ;;
     esac
done   
