#
# get the number of interrogations per minute on locked radars
#
# 2 COLUMBUS     159.389  8 8 53241.088  4.61 3.130e-08   7.0 143.8
# 2 DAYTON       162.759  9 8 53213.501  4.62 3.132e-08  59.0 259.1
# 2 COLUMBUS     164.005  8 8 53241.088  4.62 4.103e-08   7.0 143.8
# 2 DAYTON       167.377  8 8 53213.501  4.62 0.000e+00  59.0 259.1
# 2 COLUMBUS     168.626  9 8 53241.085  4.62 2.157e-08   7.0 143.8
#
if (! -e $ARGV[0]) {
    print "Must have a file\n";
}

open(FILE, "$ARGV[0]") || die("cant open my data file");

%intgData = ();

while (<FILE>) {
    if (/^2 /)  {
        if (!/LONDON/) {
           @pieces = split(' ', $_);
           $thisTime = $pieces[2];
           $thisHits = $pieces[3];
           $intgData{int($thisTime / 60)} += $thisHits;
        }
    }
}

open(GNUFILE, ">c:/tmp/gnuplot.dat") || die("Cant open gnuplot file");

print GNUFILE << "GnuHeader";
set title "Interrogations per Minute";
set xrange [0:120]
set yrange [0:150]
set xlabel \"Minutes\"
set ylabel \"Intgs\"
set grid
plot '-' with lines
GnuHeader

foreach $i (sort {$a <=> $b} keys %intgData) {
   print GNUFILE $i, " ", $intgData{$i}, "\n";
}

print GNUFILE << "GnuTrailer";
e
pause -1 "Hit return"
GnuTrailer

close(GNUFILE);

system("c:\\gnuplot\\wgnuplot.exe c:\\tmp\\gnuplot.dat");
