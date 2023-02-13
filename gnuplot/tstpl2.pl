
open(PIPE, "|pipe-gnuplot") || die("Can't talk to GNU Plot");

#
# set the file buffer to 0
#
select("PIPE");
$| = 1;

print PIPE << "HereDoc";
set title "Testing"
set xrange [-10:10]
set yrange [-1:1]
plot '-'

HereDoc

foreach (-100..100) {
   print PIPE $_, "  ", sin($_ / 10), "\n";
}

print PIPE "e\n\n";

$foo = <>;

print PIPE "set samples 50\n";
print PIPE "plot [-10:10] sin(x/2),cos(x/2)\n";

$foo = <>;

close(PIPE);

