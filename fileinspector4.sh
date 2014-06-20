#!/bin/bash

#Date: 06/12/14
#Version: 4
#Creator: Neer Shrestha
 
clear 

cleanup()
{
rm -Rf $TEMPDIR
echo "ByeBye. Have a nice day!"
logger "The temporary directory is removed."
exit
}

trap cleanup SIGINT SIGKILL EXIT


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
       \?) echo "$(basename $0): Unknown Option---$OPTARG"
           exit ;;
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

messageformat()
{
if [[ $LOG = true ]]; then
  formatmessagefunction "$1" >> $LOGFILE
else
  formatmessagefunction "$1" >> $TEMPFILE
fi
}

errormessagefunction()
{
formatmessagefunction "$1" >&2
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

nolog_option()
{
if ! [[ -e $TEMPDIR ]]; then
   TEMPDIR=$(mktemp -d ~/bin/temporary/tempdir.XXXXXX)
fi   
TEMPFILE=$(mktemp $TEMPDIR/tempfile.XXXXXX)
}

if [[ $# = 0 ]]; then
   argsyntaxerror "$(date): $(whoami): Syntax error: $(basename $0) [ARGUMENT]..." | tee -a /root/bin/fileinspector2.log 
   exit 
fi 		


if [[ $LOG = true ]]; then
          echo "The '$(basename $0)' script was run on $(date) by the USER '$USER'." >> "$LOGFILE"
fi


mainfunction()
{
if [[ $OLDEXT != $FILEEXT && $VERBOSE = true && $LOG = true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              formatmessagefunction "The $ITEM file is successfully renamed to $ITEM.$FILEEXT"
              log_option
              messageformat "The $ITEM file with '$FILETYPE' filetype is successfully renamed to $ITEM.$FILEEXT" 
              return 0

elif [[ $OLDEXT != $FILEEXT && $VERBOSE = true && $LOG != true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              formatmessagefunction "The $ITEM file is successfully renamed to $ITEM.$FILEEXT"
              nolog_option
              messageformat "The $ITEM file with '$FILETYPE' filetype is successfully renamed to $ITEM.$FILEEXT" 
              return 0

elif [[ $OLDEXT != $FILEEXT && $VERBOSE != true && $LOG != true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              nolog_option
              messageformat "The $ITEM file with '$FILETYPE' filetype is successfully renamed to $ITEM.$FILEEXT" 
              return 0

elif [[ $OLDEXT != $FILEEXT && $LOG = true ]]; then
              mv ${ITEM} ${ITEM}.${FILEEXT}
              log_option
              messageformat "The $ITEM file with filetype '$FILETYPE' is successfully renamed to $ITEM.$FILEEXT" 
              return 0

elif [[ $OLDEXT = $FILEEXT && $VERBOSE = true && $LOG = true ]]; then
              log_option              
              formatmessagefunction "The $ITEM file cannot be renamed. It is already with the correct extension."
              errormessagefunction "The $ITEM file with '$FILETYPE' filetype cannot be renamed. It is already with the correct extension."
              return 1
 
elif [[ $OLDEXT = $FILEEXT && $VERBOSE = true && $LOG != true ]]; then
              formatmessagefunction "The $ITEM file cannot be renamed. It is already with the correct extension."
              nolog_option
              errormessagefunction "The $ITEM file with '$FILETYPE' filetype cannot be renamed. It is already with the correct extension."
              return 1
fi
}


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
   if [[ $? = 0 ]]; then
      logger "The file/s are successfully renamed."  
   else
      logger "Sorry, the file/s cannot be renamed."
   fi

else
    errormessagefunction "WARNING! The $ARGITEM file or directory doesn't exist. Please enter another file or directory."
     
fi

done
    
IFS=$IFSOLD

