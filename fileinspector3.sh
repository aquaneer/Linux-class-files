#!/bin/bash

#Date: 06/09/14
#Version: 3
#Creator: Neer Shrestha
 
clear 

while getopts :dvf:l: opt; do
    case $opt in
       d) set -x ;;
       v) VERBOSE=true ;;
       l) LOG=true
          LOGFILE=$OPTARG
          if [[ $LOGFILE =~ ^-.* ]]; then
            echo "$(basename $0): option requires an argument -- 'l'"
            exit          
          fi ;;
       f) FILE=true
          FILENAME=$OPTARG 
          if [[ $FILENAME =~ ^-.* ]]; then
            echo "$(basename $0): option requires an argument -- 'f'"
            exit
          fi ;;
       \?) echo "$(basename $0): Unknown Option" ;;
    esac
done 

shift $(( $OPTIND - 1 ))

argsyntaxerror()
{
echo "$1"
}


fileext()
{
   if [[ $FILE = true ]]; then
        if [[ -e $FILENAME ]]; then
            FILEINPUT=$(grep "${FILETYPE}" "${FILENAME}")
            FILEEXT=$(echo ${FILEINPUT##*##})
        else
            argsyntaxerror "$FILENAME doesnot exist. Please input a valid filename."
            exit
        fi
   else
        FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)
        FILEEXT=$(echo ${FILEINPUT##*##})
   fi
}


formatmessagefunction()
{
echo "***********************************************************"
echo "$1"
echo "***********************************************************"
}


errormessagefunction()
{
formatmessagefunction "$1"
}


setupfunction()
{
if [[ -f "$1" ]]; then
     formatmessagefunction "'$1' log file already exists."
else
     touch $1     
     formatmessagefunction "Successfully created a new log file '$1'."
fi
}

log_option()
{
    DIR=$(dirname "$LOGFILE")
    FILE=$(echo ${LOGFILE##*/}) 
    if [[ $DIR = "." ]]; then
       echo "Creating a new file $LOGFILE in the current directory..."
       setupfunction "$LOGFILE"
    else
       echo "Creating a new log file $FILE in the $DIR directory..."    
       setupfunction "$LOGFILE"
    fi
}    


if [[ $# = 0 ]]; then
   argsyntaxerror "$(date): $(whoami): Syntax error: $(basename $0) [ARGUMENT]..." | tee -a /root/bin/fileinspector2.log 
   exit 
fi 		


mainfunction()
{
if [[ $OLDEXT != $FILEEXT && $VERBOSE = true && $LOG = true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              formatmessagefunction "The $ITEM file is successfully renamed to $ITEM.$FILEEXT"
              log_option
              formatmessagefunction "The $ITEM file with '$FILETYPE' filetype is successfully renamed to $ITEM.$FILEEXT" >> "$LOGFILE"
elif [[ $OLDEXT != $FILEEXT && $VERBOSE = true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              formatmessagefunction "The $ITEM file is successfully renamed to $ITEM.$FILEEXT"
elif [[ $OLDEXT != $FILEEXT && $VERBOSE != true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
elif [[ $OLDEXT != $FILEEXT && $LOG = true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              log_option
              formatmessagefunction "The $ITEM file with filetype '$FILETYPE' is successfully renamed to $ITEM.$FILEEXT" >> "$LOGFILE"
elif [[ $OLDEXT = $FILEEXT && $VERBOSE = true && $LOG = true ]]; then
              log_option              
              errormessagefunction "The $ITEM file cannot be renamed. It is already with the correct extension."
              errormessagefunction "The $ITEM file with '$FILETYPE' filetype cannot be renamed. It is already with the correct extension." >> "$LOGFILE"
elif [[ $OLDEXT = $FILEEXT && $VERBOSE = true ]]; then
              errormessagefunction "The $ITEM file cannot be renamed. It is already with the correct extension."

fi
}

if [[ $LOG = true ]]; then
          echo "The '$(basename $0)' script was run on $(date) by the USER '$USER'." >> $LOGFILE
fi

for ARGITEM in "$@"; do
if [[ -e $ARGITEM ]]; then
   if [[ -d $ARGITEM ]]; then
      IFSOLD=$IFS
      IFS=$'\t\n'
      LIST=$(find $ARGITEM \( ! -regex '.*/\..*' \) -type f)
   elif [[ -f $ARGITEM ]]; then
      LIST=$ARGITEM
   fi  
         
   for ITEM in $LIST; do
          FILETYPE=$(file -b --mime-type "${ITEM}")
          fileext
          OLDEXT=$(echo ${ITEM#*.})
          mainfunction   
   done
          
else
    errormessagefunction "WARNING! The $ARGITEM file or directory doesn't exist. Please enter another file or directory."
fi

done
    
IFS=$IFSOLD

