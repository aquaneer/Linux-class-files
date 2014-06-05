#!/bin/bash


touch mediafiles.txt
touch xmllist.txt

grep -o 'lh.*mp[g3]' ~/medialab/media.xml | sort > xmllist.txt

ls ~/medialab | grep -v 'media.xml' > mediafiles.txt

echo -e "Files not in media.xml:\n$(comm -23 mediafiles.txt xmllist.txt)"

echo -e "\n$(comm -23 mediafiles.txt xmllist.txt | wc -l) media files found that are not listed in media.xml."

rm mediafiles.txt
rm xmllist.txt


