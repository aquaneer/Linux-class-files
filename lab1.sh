#!/bin/bash

LISTMEDIALAB=$(ls ~/medialab | grep -v 'media.xml' | sort | uniq)

grep '.*mp[g3]' ~/medialab/media.xml | awk -F "[<>]" '{print $3}' | sort | uniq > newfile

COUNTER=0

echo -e "Files not in media.xml:\n"
 
for ITEM in $LISTMEDIALAB
do
   FOUND=$(grep "$ITEM" newfile)
   if [[ -z $FOUND ]]; then        
      echo "$ITEM"
      ((COUNTER++)) 
   fi
done

rm newfile

echo -e "\n$COUNTER media files found that are not listed in media.xml."


