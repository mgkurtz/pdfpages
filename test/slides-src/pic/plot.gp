set terminal epslatex color solid

set linestyle 1 lw 4
set linestyle 2 lw 4
set linestyle 3 lw 4

set xrange [-3:3]
set yrange [-12:12]

set xlabel 'x'
set ylabel 'y'

set xzeroaxis
set yzeroaxis

set size .9,.9

set output 'plot1.eps'
set key 1.5,-5 Left reverse
plot x**3-4*x title "$x^3-4x$" ls 1
!epstopdf plot1.eps

set output 'plot2.eps'
set key 1.5,-7.5 Left reverse
plot 3*x**2-4 title "$3x^2-4$" ls 2
!epstopdf plot2.eps

set output 'plot3.eps'
set key 1.5,-10 Left reverse
plot 6*x title "$6x$" ls 3
!epstopdf plot3.eps

### Local Variables:
### mode:sh
### End:
