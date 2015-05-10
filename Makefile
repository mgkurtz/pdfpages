VERSION=$(shell grep '\\def\\AM@fileversion{' pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{\(.*\)}/\1/')
DIST=pdfpages-$(VERSION)

DIST-FILES=pdfpages.ins pdfpages.dtx README dummy.pdf dummy-l.pdf
CTAN-DOC-FILES=pdfpages.pdf

TDS-STY-FILES=pdfpages.sty pppdftex.def ppluatex.def ppvtex.def ppxetex.def ppdvipdfm.def ppdvips.def ppnull.def
TDS-DOC-FILES=pdfpages.pdf pdf-ex.tex pdf-hyp.tex pdf-toc.tex \
	 dummy.pdf dummy-l.pdf
TDS-SRC-FILES=pdfpages.dtx pdfpages.ins README

TDS-STY-DIR=tex/latex/pdfpages
TDS-DOC-DIR=doc/latex/pdfpages
TDS-SRC-DIR=source/latex/pdfpages

TMP-DIR=pdfpages-tmp

all: sty

installer=pdfpages.installer
ins:
	echo '\\input{docstrip}\\askforoverwritefalse\\generate{\\file{pdfpages.ins}{\\from{pdfpages.dtx}{installer}}}\\endbatchfile' > $(installer)
	latex $(installer)
	rm $(installer)

sty: ins
	latex pdfpages.ins

release: distclean svn-update ins
	tex pdfpages.ins
	echo '\PassOptionsToClass{a4paper}{ltxdoc}' > ltxdoc.cfg
	-pdflatex -interaction=nonstopmode pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	rm ltxdoc.cfg

	mkdir $(TMP-DIR)
	cp $(DIST-FILES) $(CTAN-DOC-FILES) $(TMP-DIR)
	mkdir -p $(TMP-DIR)/$(TDS-STY-DIR)
	cp $(TDS-STY-FILES) $(TMP-DIR)/$(TDS-STY-DIR)
	mkdir -p $(TMP-DIR)/$(TDS-DOC-DIR)
	cp $(TDS-DOC-FILES) $(TMP-DIR)/$(TDS-DOC-DIR)
	mkdir -p $(TMP-DIR)/$(TDS-SRC-DIR)
	cp $(TDS-SRC-FILES) $(TMP-DIR)/$(TDS-SRC-DIR)

	chmod 755 $(TMP-DIR)
	find $(TMP-DIR) -type d -exec chmod 755 {} \;
	find $(TMP-DIR) -type f -exec chmod 644 {} \;

	cd $(TMP-DIR); zip -r pdfpages.tds.zip tex doc source
	cd $(TMP-DIR); chmod 644 pdfpages.tds.zip
	cd $(TMP-DIR); rm -r tex doc source

	cd $(TMP-DIR); tar cjfh $(DIST).tar.bz2 *
	cd $(TMP-DIR); chmod 644 $(DIST).tar.bz2
	cd $(TMP-DIR); rm $(DIST-FILES) $(CTAN-DOC-FILES) pdfpages.tds.zip
	rm -rf $(DIST)
	mv $(TMP-DIR) $(DIST)

svn-update:
	svn up

svn-tag:
	svn copy file:///home/andreas/svn/pdfpages/trunk file:///home/andreas/svn/pdfpages/$(VERSION) -m "Version $(VERSION)"


clean:
	rm -f pdfpages.{sty,aux,log,toc,out,dvi,pdf}
	rm -f $(TDS-STY-FILES)
	rm -f pdf-ex.{tex,log,aux}
	rm -f pdf-hyp.{tex,log,aux}
	rm -f pdf-toc.{tex,log,aux}
	rm -rf $(TMP-DIR)

distclean: clean
	rm -f *.bz2 pdfpages.ins
