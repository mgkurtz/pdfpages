#!/bin/bash

basename=$(basename $0)

function usage (){
    echo "Usage: $basename <file_1> <file_2>"
}

function file_not_found (){
    echo "$basename: File \`$1' not found."
    exit 1
}

if [ $# -ne 2 ]
then
    usage
    exit 1
fi

fileA=$1
fileB=$2

test -f $fileA || file_not_found $fileA
test -f $fileB || file_not_found $fileB

#
# key sequences
#
KEY_PAGE_UP=$'\e[5~'
KEY_PAGE_DOWN=$'\e[6~'
KEY_CURSOR_UP=$'\e[A'
KEY_CURSOR_DOWN=$'\e[B'
KEY_CURSOR_RIGHT=$'\e[C'
KEY_CURSOR_LEFT=$'\e[D'
KEY_ESCAPE=$'\e'
KEY_HOME=$'\e[H'
KEY_END=$'\e[F'

#
# mupdf commands
#
NEXT_PAGE=period
PREV_PAGE=comma
FIT_PAGE=Z
FIT_WIDTH=W
FIT_HEIGHT=H
FILE_EXIT=q
GOTO_FIRST_PAGE=g
GOTO_LAST_PAGE=G

# WID of terminal window
WID_TERMINAL=$(xdotool getwindowfocus)


W=670; H=970
function start_mupdf(){
    # $1 ... file
    # $2 ... x-position of window
    mupdf -r70 $1 &
    PID=$!
    sleep 0.1
    WID=$(xdotool getwindowfocus)

    if [ "$WID" = "$WID_TERMINAL" ]
    then
        echo "$basename: Something's wrong. Probably mupdf started"
        echo "too slow. Increase time of sleep command. Exiting now ..."
        exit
    fi

    xdotool windowsize $WID $W $H
    xdotool windowmove $WID $2 0
    xdotool key --window $WID $FIT_PAGE
    xdotool set_window --name "$1" $WID

}

function ReadKey() {
    # read first char
    if read -sN1 _REPLY; then
        # read rest of chars
        while read -sN1 -t 0.001 ; do
            _REPLY+="${REPLY}"
        done
    fi
    #echo "key: ${_REPLY}"
}



#
# main
#
start_mupdf $fileA  0
PID_A=$PID
WID_A=$WID

start_mupdf $fileB  $W
PID_B=$PID
WID_B=$WID

xdotool windowfocus $WID_TERMINAL
#xdotool windowactivate $WID_TERMINAL
PAGENR=""
while ReadKey  ; do
    case "${_REPLY}" in
        $KEY_PAGE_UP | $KEY_CURSOR_UP)
            xdotool key -window $WID_A $PREV_PAGE
            xdotool key -window $WID_A $FIT_PAGE
            xdotool set_window --name "$fileA" $WID_A
            xdotool key -window $WID_B $PREV_PAGE
            xdotool key -window $WID_B $FIT_PAGE
            xdotool set_window --name "$fileB" $WID_B
            ;;
        $KEY_PAGE_DOWN | $KEY_CURSOR_DOWN)
            xdotool key -window $WID_A $NEXT_PAGE
            xdotool key -window $WID_A $FIT_PAGE
            xdotool set_window --name "$fileA" $WID_A
            xdotool key -window $WID_B $NEXT_PAGE
            xdotool key -window $WID_B $FIT_PAGE
            xdotool set_window --name "$fileB" $WID_B
            ;;
        [0-9])
	    xdotool key -window $WID_A ${_REPLY}
	    xdotool key -window $WID_B ${_REPLY}
            ;;
        g | $KEY_HOME)
            xdotool key -window $WID_A g
            xdotool key -window $WID_A $FIT_PAGE
            xdotool set_window --name "$fileA" $WID_A
            xdotool key -window $WID_B g
            xdotool key -window $WID_B $FIT_PAGE
            xdotool set_window --name "$fileB" $WID_B
            PAGENR=""
            ;;
        G | $KEY_END)
            xdotool key -window $WID_A $GOTO_LAST_PAGE
            xdotool key -window $WID_A $FIT_PAGE
            xdotool set_window --name "$fileA" $WID_A
            xdotool key -window $WID_B $GOTO_LAST_PAGE
            xdotool key -window $WID_B $FIT_PAGE
            xdotool set_window --name "$fileB" $WID_B
            ;;
        q | $KEY_ESCAPE)
            kill $PID_A
            kill $PID_B
            break
            ;;
    esac
done
