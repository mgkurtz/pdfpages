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


all: link-package-files $(subdirs)

.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: link-package-files
link-package-files:
	$(foreach file, $(PACKAGE_FILES), ln -sf ../$(file) .;)

.PHONY: unlink-package-files
unlink-package-files:
	rm -f $(PACKAGE_FILES)

.PHONY: test
test: all
	./run-tests.sh --batch

.PHONY: clean
clean: $(subdirs)
	rm -f *.log *.aux *.out *.toc *.lof *.lot *.lol *.pdc
	rm -f *.dvi *.ps *.pdf

.PHONY: distclean
distclean: $(subdirs) clean unlink-package-files

