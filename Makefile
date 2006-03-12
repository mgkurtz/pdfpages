DIST-FILES=pdfpages.ins pdfpages.dtx pic.tex readme

VERSION=$(shell grep '\\def\\AM@fileversion{' pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{\(.*\)}/\1/')


release:
	tar cjf pdfpages-${VERSION}.tar.bz2 ${DIST-FILES}


clean:
	rm -f pdfpages.sty pppdftex.def ppvtex.def
	rm -f pdfpages.{aux,log,toc,dvi}
	rm -f pdf-ex.{tex,log,aux}
	rm -f pdf-hyp.{tex,log,aux}
	rm -f pdf-toc.{tex,log,aux}

distclean: clean