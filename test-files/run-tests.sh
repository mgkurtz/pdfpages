#!/bin/bash

basename=$(basename $0)

#
# usage
#
function usage ()
{
    echo "Usage: $basename <options>"
    echo ""
    echo "    --engines     Program names of latex to be used,"
    echo "                    e.g.: --engines=\"lualatex-80 xelatex\""
    echo "    --tests       File names of tests (without extension \`.tex')"
    echo "                    to be run, e.g.: --tests=\"fulltest-a floats-1\""
    echo "    --list-tests  List available tests."
    echo "-b, --batch       Batch mode."
    echo "-c, --clean       Clean directory."
    echo "    --old         Delete links to recent development, i.d. use"
    echo "                    pdfpages version from TEXMF-tree"
    echo "-h, --help        Display this help and exit."
    exit 0
}

if [ $# == 0 ]; then
    usage
    exit
fi

#
# defaults
#
TESTS="
  fulltest-a
  fulltest-b
  fulltest-c

  misc-1

  floats-1
  floats-2
  floats-3
  mixed

  tricky
  minimal
  crop-test
  test-import

  addtotoc-1a
  addtotoc-1b
  addtotoc-2a
  addtotoc-2b
  addtotoc-3a
  addtotoc-3b
  addtotoc-3c
  addtotoc-3d
  addtotoc-4

  addtolist-1a
  addtolist-1b
  addtolist-1c
  addtolist-2a
  addtolist-2b
  addtolist-2c

  addto-tocloft-a
  addto-tocloft-b
  addtotoc-jura

  demo-1
  demo-2
  demo-3
  demo-4

  pagecommand

  weird-filenames
  merge

  regression-1
  regression-2

  globalopts

  landscape-1
  landscape-2

  expand-args

  twocolumn-1
  twocolumn-2

  subfiles-1
"

PDF_VIEWER=evince

# tests to be run with other engines, e.g. ps4pdf
SPECIAL_TESTS="
  ps-tricks
  dvi-mode
  full-dvips
  check-status
"
TESTS="$TESTS $SPECIAL_TESTS"

LATEX_ENGINES="pdflatex lualatex xelatex platex"
LATEX_ENGINES="lualatex"

BATCH=false

PDFPAGES_FILES="pdfpages.sty pppdftex.def ppluatex.def ppxetex.def ppdvips.def ppdvipdfmx.def ppvtex.def ppnull.def"

OLD=false

#
# parsing arguments
#
OPTS="$(getopt -n $basename -options="hbc" --longoptions="help engines: tests: list-tests batch clean old" -- "$@")"
eval set -- $OPTS

while true; do
    case "$1" in
        "-h" | "--help")
            usage
            shift ;;
        "--engines")
            LATEX_ENGINES="$2"
            shift; shift
            ;;
        "--tests")
            TESTS="$2"
            shift; shift
            ;;
        "--list-tests")
            echo "Available tests:"
            echo "----------------"
            for i in $TESTS; do echo "    $i"; done
            exit 0
            ;;
        "-b" | "--batch")
            BATCH=true
            shift
            ;;
        "-c" | "--clean")
            rm -f *.{aux,log,out,toc,lof,lot,lol,pdc,pdf,ps}
            ln -sf dum/dummy.pdf .
            ln -sf dum/dummy-l.pdf .
            ln -sf dum/1.pdf .
            ln -sf dum/2-4.pdf .
            exit 0
            ;;
        "--old")
            OLD=true
            shift
            ;;            
        "--")
            shift; break
            ;;
        *)
            break
            ;;
    esac         
done


#
# do test files exists?
#
function file_not_found ()
{
    echo "$basename: File \`$1' not found."
    exit 1
}

for i in $TESTS
do
    test -f $i.tex || file_not_found $i.tex
done

#
# create links to recent developement?
#
if $OLD
then
    rm -f $PDFPAGES_FILES
else
    for i in $PDFPAGES_FILES; do
        ln -sf ../$i
    done
fi

#
# running tests
#
function message()
{
    echo "************************************************************************"
    echo "***"
    echo "***   $1"
    echo "***"
    echo "***   Test:  $2"
    echo "***"
    echo "************************************************************************"
}

function if_not_batch ()
{
    if ! $BATCH; then
        $@ &
        echo "<press return> ..."
        read
    fi
}

function post_run ()
{
    if type -t post_run_$1 | grep -i function > /dev/null; then
        post_run_$1 $2
    fi
}

function post_run_platex ()
{
    dvipdfmx $1
}

function run ()
{
    if type -t run_$1 | grep -i function > /dev/null; then
        run_$1 $2
    else
        $1 $2
    fi
}

function run_platex ()
{
    platex "\\def\\myClassOptions{dvipdfmx}\\input{$1}"
}

function regular_test()
{
    for LATEX in $LATEX_ENGINES
    do
        message ${LATEX^^} $1
        run $LATEX $1
        run $LATEX $1
        run $LATEX $1
        post_run $LATEX $1
        RES="$1-$LATEX.pdf"
        ALL_TESTS="$ALL_TESTS $RES"
        mv $1.pdf $RES

        if_not_batch $PDF_VIEWER $RES
    done
}

function msg_error()
{
    echo $(printf "\033[1;31mError: $1 \033[0;m")
    exit 1
}

function special_test()
{
    case $1 in
        ps-tricks)
            message PS4PDF $i
            ps4pdf $1
            RES=ps-tricks.pdf
            if_not_batch $PDF_VIEWER $i.pdf
            ;;
        dvi-mode)
            message LATEX $i
            latex $1
            RES=dvi-mode.dvi
            if_not_batch xdvi $i
            ;;
        full-dvips)
            message DVIPS $i
            latex $i
            dvips $i
            ps2pdf $i.ps
            RES=full-dvips.ps
            if_not_batch $PDF_VIEWER $i.pdf
            ;;
        check-status)
            message LUALATEX $i
            lualatex $i
            diff <(grep -A2 'pdfpages file:' $1.log) check-status.diff.txt
            if [ $? -ne 0 ]; then
                msg_error "Check not passed: \\AM@includegraphics@status";
            fi
            RES=check-status.pdf
            ;;

        *)
            echo "!!! Sorry, I don't know how to run special test \`$1'."
            exit
            ;;
    esac
    ALL_TESTS="$ALL_TESTS $RES"
}


for i in $TESTS
do
    if ! $(echo $SPECIAL_TESTS | grep -q $i)
    then
        regular_test $i
    else
        special_test $i
    fi
    
done


#
# backup results
#
DEST=results_$(date -I)
test -d $DEST || mkdir $DEST
test "$ALL_TESTS" != "" && mv $ALL_TESTS $DEST

#
# cleanup
#
./$0 -c
