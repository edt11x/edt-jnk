plot 'gnuplot.dat' using 1:2:(sprintf("(%d, %d)", $1, $2)) with labels
pause -1
