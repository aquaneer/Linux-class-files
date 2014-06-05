#!/bin/bash

clear
VAR=$1

if [[ -e $VAR ]]; then
   if [[ -d $VAR ]]; then
      IFSOLD=$IFS
      IFS=$'\t\n'      
      LIST=$(find "$VAR" -type f)  
      for ITEM in $LIST; do
          FILETYPE=$(file -b --mime-type "${ITEM}")
          FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)
          FILEEXT=$(echo ${FILEINPUT##*##})
          OLDEXT=$(echo ${ITEM#*.})
          if [[ $OLDEXT != $FILEEXT ]]; then
              mv "${ITEM}" "${ITEM}.${FILEEXT}"
          fi      
      done   
   elif [[ -f $VAR ]]; then
         FILETYPE=$(file -b --mime-type "$VAR") 
         FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)   
         FILEEXT=$(echo ${FILEINPUT##*##}) 
         OLDEXT=$(echo ${VAR#*.})
         if [[ $OLDEXT != $FILEEXT ]]; then
              mv "${VAR}" "${VAR}.${FILEEXT}"
         fi
   fi
else
   echo "The file or directory doesn't exist. Please enter another file or directory."
fi  

IFS=$IFSOLD
