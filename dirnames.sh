#!/bin/bash

#Assign first argument to a variable.
VAR="$1"

echo ${VAR%.*}

