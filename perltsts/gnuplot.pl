
open(PLOTTST, "|pipe-gnuplot") || die("Can't open GNU Plot Pipe");

print PLOTTST << "GnuHeader";
set title "test plot"
set xrange [0:255]
set yrange [0:255]
set grid
plot '-'
GnuHeader

foreach (1..100) {
    print PLOTTST "$_ $_ \n";
}

print PLOTTST << "GnuTrailer";
e
GnuTrailer

close(PLOTTST);


