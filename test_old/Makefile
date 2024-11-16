subdirs := booklet sub

PACKAGE_FILES= \
	pdfpages.sty \
	pdfpages.sty \
	pppdftex.def \
	ppluatex.def \
	ppxetex.def \
	ppdvipdfmx.def \
	ppdvips.def \
	ppvtex.def \
	ppnull.def


all: link-package-files link-test-files $(subdirs)

.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: link-package-files
link-package-files:
	$(foreach file, $(PACKAGE_FILES), ln -sf ../$(file) .;)

.PHONY: link-test-files
link-test-files:
	ln -sf pdf/1.pdf .
	ln -sf pdf/2-4.pdf .

.PHONY: unlink-package-files
unlink-package-files:
	rm -f $(PACKAGE_FILES)

.PHONY: unlink-test-files
unlink-test-files:
	rm -f 1.pdf 2-4.pdf

.PHONY: clean
clean: $(subdirs)
	rm -f *.log *.aux *.out *.toc *.lof *.lot *.lol *.pdc
	rm -f *.dvi *.ps
	find -maxdepth 1 \
	     -name "*.pdf" \
	     ! -name "1.pdf" \
	     ! -name "2-4.pdf" \
	     -exec rm {} \;

.PHONY: distclean
distclean: $(subdirs) clean unlink-package-files unlink-test-files

