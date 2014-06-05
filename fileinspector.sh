#!/bin/bash

VAR=$1

if [[ $# = 0 ]]; then
   echo "Please enter name of a directory or file."
   exit
elif [[ $# -ne 1 ]]; then
   echo "Sorry, currently this script can only handle 1 argument. Please enter only 1 argument in the command line."
   exit
fi 		


if [[ -e $VAR ]]; then
   if [[ -d $VAR ]]; then
      LIST=$(ls "$VAR")
      for ITEM in $LIST; do
          FILETYPE=$(file -b --mime-type "${VAR}/${ITEM}")
          FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)
          FILEEXT=$(echo ${FILEINPUT##*##})
          OLDEXT=$(echo ${ITEM#*.})
          if [[ $OLDEXT != $FILEEXT ]]; then
               mv ${VAR}/${ITEM} ${VAR}/${ITEM}.${FILEEXT}
          fi      
      done   
   elif [[ -f $VAR ]]; then
         FILETYPE=$(file -b --mime-type "$VAR") 
         FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)   
         FILEEXT=$(echo ${FILEINPUT##*##}) 
         OLDEXT=$(echo ${VAR#*.})
         if [[ $OLDEXT != $FILEEXT ]]; then
              mv ${VAR} ${VAR}.${FILEEXT}
         fi
   fi
else
   echo "The file or directory doesn't exist. Please enter another file or directory."
fi  

