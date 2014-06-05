#!/bin/bash


touch mediafiles.txt
touch xmllist.txt

grep -o 'lh.*mp[g3]' ~/medialab/media.xml | sort > xmllist.txt

ls ~/medialab | grep -v 'media.xml' > mediafiles.txt

echo -e "Files not in medialab:\n$(comm -13 mediafiles.txt xmllist.txt)"

echo -e "\n$(comm -13 mediafiles.txt xmllist.txt | wc -l) media files in media.xml that are not in medialab directory."

rm mediafiles.txt
rm xmllist.txt


