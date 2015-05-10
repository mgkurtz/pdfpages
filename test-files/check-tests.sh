#!/bin/bash

basename=$(basename $0)

function usage (){
    echo "Usage: $basename <directory_1> <directory_2> [<files>]"
}

function dir_error (){
    echo "$basename: Directory \`$1' doesn't exits."
    exit 1
}

function skip_test (){
    echo "$basename: File \`$1' doesn't exit. Skipping test."
}

if [ $# -lt 2 ]
then
    usage
    exit 1
fi

dirA=$1
dirB=$2
shift; shift
files=$@

test -d $dirA || dir_error $dirA
test -d $dirB || dir_error $dirB

if [ "$files" = "" ]
then
    files=$(cd $dirA; ls -x *.pdf)
fi


#
# main loop
#
for i in $files
do

    fileA=$dirA/$i
    fileB=$dirB/$i

    if test ! -f $fileA
    then
        file_error $fileA
        continue
    elif test ! -f $fileB
    then
        file_error $fileB
        continue
    fi

    ./check-pdf.sh $fileA $fileB
   
done
