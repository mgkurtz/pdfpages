PDFS= \
	normal-portrait.pdf \
	normal-landscape.pdf \
	slim-portrait.pdf \
	slim-landscape.pdf

all: $(PDFS)

%.pdf: %.tex
	lualatex $<
	lualatex $<

.PHONY: clean
clean:
	rm -f *.aux *.log

.PHONY: distclean
distclean: clean
	rm -f *.pdf

test:
