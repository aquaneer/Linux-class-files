#!/bin/bash

# placing a : before the options allows us to handle errors with our \?) case item

while getopts :ab:c: opt
do
        case $opt in
                a) echo "Found the -a option" ;;
                b) echo "Found the -b option with value $OPTARG" ;;
                c) echo "Found the -c option with value $OPTARG" ;;
                \?) echo "$(basename $0): Unknown option" ;;
        esac
done

shift $(( $OPTIND - 1 ))
#shift
# option index is the NEXT option to process
# we want to shift backward to get the regular arguments

echo "\$1 is $1"
echo "\$2 is $2"
echo "\$3 is $3"
echo "\$4 is $4"
