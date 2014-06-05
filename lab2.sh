#!/bin/bash

LIST=$(grep '.*mp[g3]' ~/medialab/media.xml | awk -F "[<>]" '{print $3}' | sort | uniq) 

COUNTER=0

echo -e "Files not in medialab:\n"
 
cd ~/medialab

for ITEM in $LIST
do
      if [[ -f ./${ITEM} ]]; then
           continue 
      else
	   echo ${ITEM}
	   ((COUNTER++))       
      fi
done

echo -e "\n${COUNTER} media files in media.xml that are not in medialab directory."











