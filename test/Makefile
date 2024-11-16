lvt-files := $(wildcard *.lvt)
aux-files := $(wildcard *.aux *.log *.toc *.lof *.lot *.lol *.out *.mfl *.pdc)
out-files := $(wildcard *.pdf *.ps *.dvi)

package-files := \
	pdfpages.sty \
	ppnull.def \
	ppluatex.def \
	pppdftex.def \
	ppxetex.def \
	ppdvips.def \
	ppdvipdfmx.def \
	ppvtex.def


.PHONY: all
all: support-files $(package-files)
$(package-files):
	ln -sf ../$@

.PHONY: support-files
support-files:
	$(MAKE) -C ../ sty
	$(MAKE) -C ./support support-files
	$(MAKE) -C ./subdir

subdirs := support subdir
.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean
clean: $(subdirs)
	rm -f $(aux-files)
	rm -f $(lvt-files:.lvt=.pdf) \
	      $(lvt-files:.lvt=.dvi) \
              $(lvt-files:.lvt=.xdv) \
	      $(lvt-files:.lvt=.ps)
	rm -f ps-tricks-pics.*
	rm -rf auto/

.PHONY: distclean
distclean: clean $(subdirs)
	rm -f $(package-files)
	rm -f $(out-files)
	rm -f hog.eps dummy-xbb.xbb

