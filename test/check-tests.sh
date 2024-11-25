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

shopt -s nullglob
if [ "$files" = "" ]
then
    files=$(cd $dirA; ls -x *.pdf */*.pdf)
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
        skip_test $fileA
        continue
    elif test ! -f $fileB
    then
        skip_test $fileB
        continue
    fi

    echo "Comparing $fileA and $fileB"
    ./check-pdf.sh $fileA $fileB
done
