#!/bin/bash

clear 

argsyntaxerror()
{
echo "$1"
}


fileext()
{
     FILEINPUT=$(grep "${FILETYPE}" ~/bin/filetable.txt)
     FILEEXT=$(echo ${FILEINPUT##*##})
}


fileextcheck()
{
[[ $OLDEXT != $FILEEXT ]]
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
echo "Creating a new file $1 in the root/bin directory..."
cd ~/bin
if [[ -f "$1" ]]; then
     return 1
else
     touch "$1"
     return 0
fi
}


if [[ $# = 0 ]]; then
   setupfunction fileinspector2.log
   if [[ $? = 1 ]]; then
      formatmessagefunction "root/bin/fileinspector2.log file already exists."
   else
      formatmessagefunction "Successfully created a new file root/bin/fileinspector2.log."
   fi   
   argsyntaxerror "$(date): $(whoami): Syntax error: $0 [ARGUMENT]..." | tee -a ~/bin/fileinspector2.log 
   exit
fi 		

for ARGITEM in "$@"; do
if [[ -e $ARGITEM ]]; then
   if [[ -d $ARGITEM ]]; then
      IFSOLD=$IFS
      IFS=$'\t\n'
      LIST=$(find "$ARGITEM" -type f)
      for ITEM in $LIST; do
          FILETYPE=$(file -b --mime-type "${ITEM}")
          fileext
          OLDEXT=$(echo ${ITEM#*.})
          if fileextcheck; then
             mv ${ITEM} ${ITEM}.${FILEEXT}
             formatmessagefunction "The $ITEM file is successfully changed to $ITEM.$FILEEXT"
          else
             errormessagefunction "The $ITEM file cannot be renamed. It is already with the correct extension."
          fi
      done
          
   elif [[ -f $ARGITEM ]]; then
         FILETYPE=$(file -b --mime-type "$ARGITEM")
         fileext
         OLDEXT=$(echo ${ARGITEM#*.})
         if fileextcheck; then
            mv ${ARGITEM} ${ARGITEM}.${FILEEXT}
            formatmessagefunction "The $ARGITEM file is changed to $ARGITEM.$FILEEXT"
         else
            errormessagefunction "The $ARGITEM file cannot be renamed. It is already with the correct extension."
         fi
   fi
else
   errormessagefunction "WARNING! The $ARGITEM file or directory doesn't exist. Please enter another file or directory."
fi
done
    
IFS=$IFSOLD



