gnuplot-n = 1 2 3
gnuplot-pic = $(foreach n, $(gnuplot-n), plot$(n).tex plot$(n).pdf)

xfig-beam-depth = $(shell cat beam.depth)
xfig-pic = $(foreach n, $(xfig-beam-depth), beam-$(n).tex beam-$(n).pdf)


all : $(gnuplot-pic) $(xfig-pic)

$(gnuplot-pic) : plot.gp
	gnuplot plot.gp

$(xfig-pic) : beam.fig beam.depth
	./fig2pdf beam.fig


clean :
	rm -f beam-*.eps
	rm -f plot*.eps

distclean : clean
	rm -f beam-*.pdf beam-*.tex
	rm -f plot*.pdf plot*.tex

.PHONY : all clean distclean