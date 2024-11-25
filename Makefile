VERSION=$(shell grep '\\def\\AM@fileversion{' pdfpages.dtx |\
	sed 's/\\def\\AM@fileversion{v\(.*\)}/\1/')
DIST=pdfpages-$(VERSION)
DIST-DIR=$(DIST)

DIST-FILES= \
	pdfpages.ins \
	pdfpages.dtx \
	README \
	dummy.pdf \
	dummy-l.pdf
CTAN-DOC-FILES= \
	pdfpages.pdf
TDS-STY-FILES= \
	pdfpages.sty \
	pppdftex.def \
	ppluatex.def \
	ppvtex.def \
	ppxetex.def \
	ppdvipdfmx.def \
	ppdvips.def \
	ppnull.def
TDS-DOC-FILES= \
	pdfpages.pdf \
	pdf-ex.tex \
	pdf-hyp.tex \
	pdf-toc.tex \
	dummy.pdf \
	dummy-l.pdf
TDS-SRC-FILES= \
	pdfpages.dtx \
	pdfpages.ins \
	README

TDS-STY-DIR=tex/latex/pdfpages
TDS-DOC-DIR=doc/latex/pdfpages
TDS-SRC-DIR=source/latex/pdfpages

.PHONY: all
all: sty

.PHONY: sty
sty: ins git-config smudge
	latex pdfpages.ins

.PHONY: ins
ins:
	echo '\\input{docstrip}\\askforoverwritefalse\\generate{\\file{pdfpages.ins}{\\from{pdfpages.dtx}{installer}}}\\endbatchfile' > pdfpages.installer
	latex pdfpages.installer
	rm pdfpages.installer

.PHONY: tds
tds: sty
	echo '\PassOptionsToClass{a4paper}{ltxdoc}' > ltxdoc.cfg
	-pdflatex -interaction=nonstopmode pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	pdflatex pdfpages.dtx
	rm ltxdoc.cfg

	rm -rf $(DIST-DIR)
	mkdir $(DIST-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-STY-DIR)
	cp $(TDS-STY-FILES) $(DIST-DIR)/$(TDS-STY-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-DOC-DIR)
	cp $(TDS-DOC-FILES) $(DIST-DIR)/$(TDS-DOC-DIR)
	mkdir -p $(DIST-DIR)/$(TDS-SRC-DIR)
	cp $(TDS-SRC-FILES) $(DIST-DIR)/$(TDS-SRC-DIR)

	chmod 755 $(DIST-DIR)
	find $(DIST-DIR) -type d -exec chmod 755 {} \;
	find $(DIST-DIR) -type f -exec chmod 644 {} \;

	cd $(DIST-DIR); zip -r pdfpages.tds.zip tex doc source
	cp $(DIST-DIR)/pdfpages.tds.zip .
	cd $(DIST-DIR); chmod 644 pdfpages.tds.zip

.PHONY: release
release: git-check release-force

.PHONY: release-force
release-force: tds
	mkdir $(DIST-DIR)/pdfpages
	cp $(DIST-FILES) $(CTAN-DOC-FILES) $(DIST-DIR)/pdfpages
	cd $(DIST-DIR); rm -r tex doc source
	cd $(DIST-DIR); zip -r $(DIST).zip *
	cd $(DIST-DIR); rm -rf pdfpages pdfpages.tds.zip

.PHONY: git-check
git-check:
ifneq "$(shell git status --porcelain pdfpages.dtx)" ""
	@echo "!!!"
	@echo "!!! Cannot make release:"
	@echo "!!! There are uncommitted changes in \`pdfpages.dtx'."
	@echo "!!! To force a release, run: make release-force"
	@echo "!!!"
	@exit 1
endif
	rm pdfpages.dtx
	git checkout pdfpages.dtx

.PHONY: git-config
git-config:
	git config filter.date_sha1.clean 'scripts/git_filter_date_sha1 --clean'
	git config filter.date_sha1.smudge 'scripts/git_filter_date_sha1 --smudge'

.PHONY: smudge
smudge:
ifeq '$(findstring $$Date: YYYY-MM-DD, $(file < pdfpages.dtx))' '$$Date: YYYY-MM-DD'
	scripts/git_filter_date_sha1 --smudge <pdfpages.dtx >pdfpages-smudge.dtx
	mv pdfpages-smudge.dtx pdfpages.dtx
endif

subdirs := test
.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean
clean: $(subdirs)
	rm -f $(addprefix pdfpages, .ins .sty .aux .log .toc .out .dvi .pdf .hd)
	rm -f $(addprefix pdf-ex, .tex .log .aux)
	rm -f $(addprefix pdf-hyp, .tex .log .aux)
	rm -f $(addprefix pdf-toc, .tex .log .aux)
	rm -f $(TDS-STY-FILES)

.PHONY: distclean
distclean: clean $(subdirs)
	rm -f pdfpages.tds.zip

