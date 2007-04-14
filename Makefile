VERSION=$(shell grep '\\def\\AM@fileversion{' pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{\(.*\)}/\1/')

DIST-FILES=pdfpages.ins pdfpages.dtx README dummy.pdf dummy-l.pdf
CTAN-DOC-FILES=pdfpages.pdf

TDS-STY-FILES=pdfpages.sty pppdftex.def ppvtex.def ppxetex.def ppnull.def
TDS-DOC-FILES=pdfpages.pdf pdf-ex.tex pdf-hyp.tex pdf-toc.tex
TDS-SRC-FILES=pdfpages.dtx pdfpages.ins README dummy.pdf dummy-l.pdf

TDS-STY-DIR=tex/latex/pdfpages
TDS-DOC-DIR=doc/latex/pdfpages
TDS-SRC-DIR=source/latex/pdfpages

DIST-DIR=pdfpages-$(VERSION)


installer=pdfpages.installer
ins:
	echo '\input{docstrip}\askforoverwritefalse\generate{\file{pdfpages.ins}{\from{pdfpages.dtx}{installer}}}\endbatchfile' > $(installer)
	latex $(installer)
	rm $(installer)

sty:
	latex pdfpages.ins

release: distclean svn-update ins
	tex pdfpages.ins
	echo '\PassOptionsToClass{a4paper}{ltxdoc}' > ltxdoc.cfg
	-pdflatex -interaction=nonstopmode pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	rm ltxdoc.cfg

	mkdir $(DIST-DIR)
	cp $(DIST-FILES) $(CTAN-DOC-FILES) $(DIST-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-STY-DIR)
	cp $(TDS-STY-FILES) $(DIST-DIR)/$(TDS-STY-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-DOC-DIR)
	cp $(TDS-DOC-FILES) $(DIST-DIR)/$(TDS-DOC-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-SRC-DIR)
	cp $(TDS-SRC-FILES) $(DIST-DIR)/$(TDS-SRC-DIR)

	chmod 755 $(DIST-DIR)
	find $(DIST-DIR) -type d -exec chmod 755 {} \;
	find $(DIST-DIR) -type f -exec chmod 644 {} \;

	cd $(DIST-DIR); zip -r pdfpages-tds.zip tex doc source
	cd $(DIST-DIR); chmod 644 pdfpages-tds.zip
	cd $(DIST-DIR); rm -r tex doc source

	tar cjfh $(DIST-DIR).tar.bz2 $(DIST-DIR)
	chmod 644 $(DIST-DIR).tar.bz2
	rm -r $(DIST-DIR)

svn-update:
	svn up


clean:
	rm -f pdfpages.{sty,aux,log,toc,out,dvi,pdf}
	rm -f pppdftex.def ppvtex.def ppxetex.def ppnull.def 
	rm -f pdf-ex.{tex,log,aux}
	rm -f pdf-hyp.{tex,log,aux}
	rm -f pdf-toc.{tex,log,aux}
	rm -rf $(DIST-DIR)

distclean: clean
	rm -f *.bz2 pdfpages.ins