LaTeX = pdflatex

pdftex pdflatex : LaTeX = pdflatex
pdftex pdflatex : all

vtex vlatex : LaTeX = vlatex
vtex vlatex : all
	mv texput.pdf slides.pdf

all : pic pdf

pic :
	make -C $@

pdf :
	$(LaTeX) slides
	$(LaTeX) slides
	cp slides.pdf slides-tmp.pdf
	$(LaTeX) '\PassOptionsToPackage{final}{pdfpages} \input{slides.tex}'
	thumbpdf slides.pdf
	$(LaTeX) '\PassOptionsToPackage{final}{pdfpages} \input{slides.tex}'
	$(LaTeX) handouts
	$(LaTeX) handouts

clean :
	rm -f *.aux *.log *.out
	cd pic; rm -f beam-*.eps
	cd pic; rm -f plot*.eps

distclean : clean
	rm -f slides.pdf slides-tmp.pdf
	rm -f handouts.pdf
	rm -f slides.tpt
	make -C pic $@

.PHONY : pdftex pdflatex vtex vlatex \
	all pic pdf clean distclean
