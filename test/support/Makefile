test-dirs := ../
created-files := \
	dummy.pdf \
	dummy-a5.pdf \
	dummy-landscape.pdf \
	dummy-big.pdf \
	mixed1.pdf \
	mixed2.pdf \
	dummy1.pdf \
	dummy2.pdf \
	dummy3.pdf \
	dummy-xbb.pdf \
	dummy-xbb.xbb \
	hog.pdf \
	1.pdf \
	2-4.pdf \
	foo~bar.pdf \
	normal-portrait.pdf \
	slim-portrait.pdf \
	normal-landscape.pdf \
	slim-landscape.pdf \
	example-image-a.png \
	example-image-b.jpg
non-created-files := \
	hog.eps
include-files := $(created-files) $(non-created-files)
package-files := \
	pdfpages.sty \
	pppdftex.def \
	ppluatex.def \
	ppvtex.def \
	ppxetex.def \
	ppdvipdfmx.def \
	ppdvips.def \
	ppnull.def
aux-files := $(wildcard *.aux *.log *.toc *.lof *.out)

.PHONY: test
test: support-files

.PHONY: support-files
support-files: $(created-files) link-include-files link-package-files

.PHONY:link-include-files
link-include-files: $(foreach dir,$(test-dirs),$(addprefix $(dir),$(include-files)))

.PHONY:link-packages-files
link-package-files: $(foreach dir,$(test-dirs),$(addprefix $(dir),$(package-files)))

%.pdf: %.tex
	lualatex $<

hog.pdf: hog.eps
	epstopdf hog.eps

1.pdf: dummy.pdf
	ln -sf dummy.pdf $@

2-4.pdf: dummy.pdf
	ln -sf dummy.pdf $@

foo~bar.pdf: dummy.pdf
	ln -sf dummy.pdf $@

example-image-a.png:
	ln -sf $(shell kpsewhich $@)

example-image-b.jpg:
	ln -sf $(shell kpsewhich $@)

dummy-xbb.pdf: dummy.pdf
	ln -sf dummy.pdf $@

dummy-xbb.xbb: dummy-xbb.pdf
	extractbb $<

$(foreach dir,$(test-dirs),$(addprefix $(dir),$(include-files))):
	ln -sf ./support/$(notdir $@) $@

$(foreach dir,$(test-dirs),$(addprefix $(dir),$(package-files))):
	ln -sf ../$(notdir $@) $@

.PHONY: clean
clean:
	rm -f *.aux *.log
	rm -rf auto/

.PHONY: distclean
distclean: clean
	rm -f *.pdf

