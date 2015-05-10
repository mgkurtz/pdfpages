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
    echo "                    e.g.: --engine=\"lualatex-80 xelatex\""
    echo "    --tests       File names of tests (without extension \`.tex')"
    echo "                    to be run, e.g.: --tests=\"fulltest floats-1\""
    echo "    --show-tests  Display available tests."
    echo "-b, --batch       Batch mode."
    echo "-c, --clean       Clean directory."
    echo "    --old         Delete links to recent development, i.d. use"
    echo "                    pdfpages version from TEXMF-tree"
    echo "-h, --help        Display this help and exit."
    exit 0
}

#
# defaults
#
TESTS="
  fulltest
  floats-1
  floats-2
  floats-3
  mixed

  tricky
  minimal
  crop-test
  test-import

  addtotoc-1
  addtotoc-2
  addtotoc-3

  addtolist-1
  addtolist-2

  addto-tocloft
  addtotoc-jura
"

# tests to be run with other engines, e.g. ps4pdf
SPECIAL_TESTS="
  ps-tricks
  dvi-mode
"
TESTS="$TESTS $SPECIAL_TESTS"

LATEX_ENGINES="pdflatex lualatex xelatex"

BATCH=false

PDFPAGES_FILES="pdfpages.sty pppdftex.def ppluatex.def ppxetex.def ppdvips.def ppdvipdfm.def ppvtex.def ppnull.def"

OLD=false

#
# parsing arguments
#
OPTS="$(getopt -n $basename -options="hbc" --longoptions="help engines: tests: show-tests batch clean old" -- "$@")"
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
        "--show-tests")
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
            for i in $TESTS; do
                rm -f $i.{aux,log,out,toc,lof,lot,lol,pdc}
            done
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

function regular_test()
{
    for LATEX in $LATEX_ENGINES
    do
        $LATEX $1
        $LATEX $1
        $LATEX $1
        RES="$1-$LATEX.pdf"
        ALL_TESTS="$ALL_TESTS $RES"
        mv $1.pdf $RES

        if ! $BATCH; then
            acroread $RES &
        fi
    done
    message ${LATEX^^} $1
    if ! $BATCH; then
        echo "<press return>"
        read
    fi
}

function special_test()
{
    case $1 in
        ps-tricks)
            ps4pdf $1
            X=ps-tricks.pdf
            message PS4PDF $i
            ;;
        dvi-mode)
            latex $1
            X=dvi-mode.dvi
            message LATEX $i
            ;;
        *)
            echo "!!! Sorry, I don't know how to run special test \`$1'."
            exit
            ;;
    esac
    ALL_TESTS="$ALL_TESTS $X"
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
mv $ALL_TESTS $DEST

#
# cleanup
#
$0 -c
