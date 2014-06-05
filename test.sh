#!/bin/bash

var=$1

if [[ a = a ]]; then
IFSOLD=$IFS
IFS=$'\t\n'

LIST=$(ls -R "$var")

for ITEM in $LIST; do
echo $ITEM
done

fi

IFS=$IFSOLD
