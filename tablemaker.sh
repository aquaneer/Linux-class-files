#!/bin/bash

LIST=$(cat ~/bin/filetable.txt)

for ITEM in $LIST
do
  if echo $ITEM | grep -q '##'; then
     VAR=$(echo ${ITEM##*##})
     echo "The file extension for $ITEM filetype is $VAR."
  else
     echo "Please enter the file extension for $ITEM filetype:"
     read EXT
     NEWITEM=${ITEM}##${EXT}   
     sed -i "s@${ITEM}@${NEWITEM}@g" ~/bin/filetable.txt 
  fi
done 



