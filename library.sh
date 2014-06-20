#!/bin/bash

#Date: 06/19/2014
#Version: 1
#Creator: Neer Shrestha


setup_function()
{
  TEMPDIR=$(mktemp -d ~/bin/tempdir.XXXXXX)
  TEMPFILE=$(mktemp $TEMPDIR/tempfile.XXXXXX)
  
  COMB_USER_HOMEDIR=$(du -chs /home | grep 'total' | awk '{print $1}')
  
  EACH_USER_HOMEDIR=$(du -chs /home/$USERHOME | grep 'total' | awk '{print $1}')
  
  IP_ADDRESS=$(ifconfig eth0 | grep -o ":.*120")
  
  IP_LIST=$(awk -F '[- -]' '{print $1}' /var/share/CS225/xenmagic-access_log | sort | uniq -c | sort -n | awk '{print $2}')
  FREQUENCY_ARRAY=($(awk -F '[- -]' '{print $1}' /var/share/CS225/xenmagic-access_log | sort | uniq -c | sort -n | awk '{print $1}'))
  ARRAY_SIZE=${#FREQUENCY_ARRAY[@]}
}



cleanup()
{
  rm -Rf $TEMPDIR
  echo "*********************************************************"
  echo "Thank you for using this program. Have a nice day!"
  exit
}


log_function()
{
  logger "$1"
}


message_function()
{
echo "*****************************************************************"
echo "$1"
echo "*****************************************************************"
}


error_function()
{
message_function "$1" >&2
}

fn_eth0_IPaddress()
{
   setup_function
   message_function "The IP address of eth0 is${IP_ADDRESS}"
}

fn_combined_userhomedir()
{
   setup_function
   message_function "The combined size of all users home directories is $COMB_USER_HOMEDIR."
}
 
fn_each_userhomedir()
{
   read -p "Please enter a username whose disk usage you want to see: " USERHOME   
   if [[ -e /home/$USERHOME ]]; then
      setup_function
      message_function "The size of $USERHOME's home directory is $EACH_USER_HOMEDIR."
   else
      error_function "Sorry, the user '$USERHOME' does not exist in the system. Please try again."
      exit
   fi  
}
 
fn_show_largerfiles()
{
   read -p "Please enter a username, directory (do not include the directory path) and file size (in kb): " USERNAME DIRECTORY FILESIZE
   if [[ -e /home/$USERNAME && -e /home/$USERNAME/$DIRECTORY ]]; then
      message_function "The files owned by '$USERNAME' in '$DIRECTORY' directory that are larger than ${FILESIZE}kb are: "  
      LIST=$(find /home/$USERNAME/$DIRECTORY -type f -size +$FILESIZE)
      for ITEM in $LIST
      do
         echo ${ITEM##*/}
      done
   elif ! [[ -e /home/$USERNAME ]]; then
      error_function "Sorry, the user '$USERNAME' does not exist in the system. Please try again."
      exit 
   elif ! [[ -e /home/$USERNAME/$DIRECTORY ]]; then
      error_function "Sorry, the directory '$DIRECTORY' is either not owned by the user '$USERNAME' or does not exist."     
      exit
   fi
}

fn_webpagerequest_IP()
{
    message_function "Number of web pages accessed by IP are: "

    setup_function

    i=0
    while [[ i -lt $ARRAY_SIZE ]]
    do
       for ITEM in $IP_LIST
       do
         echo "$ITEM requested pages ${FREQUENCY_ARRAY[i]} times."
         ((i++))
       done
    done 
}

fn_copy_files()
{
    read -p "Please enter a Source directory and a Destination directory (full directory path): " SOURCE DESTINATION
    
    if [[ -d $SOURCE ]]; then
          if [[ -r $SOURCE ]]; then
              OLDIFS=$IFS
              IFS=$'\t\n'
              LIST=$(find $SOURCE -type f)
          else
              echo "Sorry, you do not have the permission to read from the Source directory." 
          fi
    else
         error_function "Source Directory does not exist. Please enter a valid Source directory."
         exit
    fi
    
        
    if ! [[ -d $DESTINATION ]]; then
          mkdir $DESTINATION 
    elif ! [[ -w $DESTINATION ]]; then
          echo "Sorry, you do not have the permission to write to the Destination directory."  
          exit
    else
          FILE=$(ls $DESTINATION)
          if ! [[ -z $FILE ]]; then
              read -p "Overwrite existing files in $DESTINATION directory? (y/n): " REPLY
          else
              REPLY=Y  
          fi          
    fi
 
    if [[ $REPLY =~ [Yy] ]]; then
         for ITEM in $LIST
         do
             echo "Copying file $ITEM to $DESTINATION..."
             if ! cp -p "$ITEM" "$DESTINATION" 2>> $0.log; then
             error_function "Sorry, the file $ITEM cannot be copied to the destination directory." 
             return 1 
             fi
         done 
     
         if [[ $? = 0 ]]; then
              log_function "Success! The files from the $SOURCE directory are copied to the $DESTINATION directory."  
         fi
     fi
           
     
   IFS=$OLDIFS
}    
    




