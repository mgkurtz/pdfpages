all: normal-portrait.pdf normal-landscape.pdf \
	slim-portrait.pdf slim-landscape.pdf

%.pdf: %.tex
	lualatex $^

.PHONY: clean
clean:
	rm -f *.aux *.log

.PHONY: distclean
distclean: clean
	rm -f *.pdf
