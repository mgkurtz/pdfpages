DIST-FILES=pdfpages.ins pdfpages.dtx README dummy.pdf dummy-l.pdf
CTAN-DOC-FILES=pdfpages.pdf

REVISION=$(shell grep Revision svninfo |\
	sed 's/$$Revision: \(.*\) $$$$/\1/')

VERSION=$(shell grep '\\def\\AM@fileversion{' pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{\(.*\)}/\1/')

BETA-VERSION=${VERSION}-beta-${REVISION}

DIST-DIR=dist
BETA-DIR=beta

installer=pdfpages.installer
ins:
	echo '\input{docstrip}\askforoverwritefalse\generate{\file{pdfpages.ins}{\from{pdfpages.dtx}{installer}}}\endbatchfile' > $(installer)
	latex $(installer)
	rm $(installer)

sty:
	latex pdfpages.ins

release: distclean ins
	tex pdfpages.ins
	echo '\PassOptionsToClass{a4paper}{ltxdoc}' > ltxdoc.cfg
	-pdflatex -interaction=nonstopmode pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	rm ltxdoc.cfg
	-mkdir foo
	cp ${DIST-FILES} ${CTAN-DOC-FILES} foo
	cd foo; chmod 644 *
	cd foo; touch ${DIST-FILES} ${CTAN-DOC-FILES}
	cd foo; tar cjfh pdfpages-${VERSION}.tar.bz2 ${DIST-FILES} ${CTAN-DOC-FILES}
	mv foo/pdfpages-${VERSION}.tar.bz2 .
	rm -r foo


beta:
	-mkdir ${BETA-DIR}
	cp ${DIST-FILES} ${BETA-DIR}
	cat pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{.*}/\\def\\AM@fileversion{${BETA-VERSION}}/' \
	> ${BETA-DIR}/pdfpages.dtx
	cd ${BETA-DIR} && tar cjf pdfpages-${BETA-VERSION}.tar.bz2 ${DIST-FILES}


clean:
	rm -f pdfpages.sty pppdftex.def ppvtex.def ppnull.def
	rm -f pdfpages.{aux,log,toc,out,dvi,pdf}
	rm -f pdf-ex.{tex,log,aux}
	rm -f pdf-hyp.{tex,log,aux}
	rm -f pdf-toc.{tex,log,aux}
	rm -rf ${BETA-DIR} ${DIST-DIR}

distclean: clean
	rm -f *.bz2 pdfpages.ins