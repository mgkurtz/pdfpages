#!/bin/bash

dir='booklet'

function create_thumbs() {
    pdftocairo -png -scale-to 200 $1 $dir/tmp
}

function join_thumbs() {
    thumb1=$dir/tmp-$(printf "%02d" $(($1+0))).png
    thumb2=$dir/tmp-$(printf "%02d" $(($1+1))).png
    thumb3=$dir/tmp-$(printf "%02d" $(($1+2))).png
    thumb4=$dir/tmp-$(printf "%02d" $(($1+3))).png
    inter1=$dir/inter-1.png
    inter2=$dir/inter-2.png
    outfile=$dir/$2

    convert $thumb1 $thumb2 +append $inter1
    convert $thumb3 $thumb4 +append $inter2
    convert $inter1 $inter2 -append $outfile
}

function cleanup() {
    rm -f $dir/tmp-*
    rm -f $dir/inter-*
}

function run() {
    echo "Creating thumbs: $1.pdf"
    file=$1
    create_thumbs $file.pdf
    join_thumbs  3 $file-1.png
    join_thumbs  9 $file-2.png
    join_thumbs 15 $file-3.png
    join_thumbs 21 $file-4.png
    join_thumbs 27 $file-5.png
    join_thumbs 33 $file-6.png
    join_thumbs 39 $file-7.png
    join_thumbs 45 $file-8.png
    cleanup
}

run booklet-portrait-left
run booklet-portrait-top
run booklet-landscape-left
run booklet-landscape-top

run booklet-flip-portrait-left
run booklet-flip-portrait-top
run booklet-flip-landscape-left
run booklet-flip-landscape-top

