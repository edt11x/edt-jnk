
open(PIPE, "|pipe-gnuplot") || die("Can't talk to GNU Plot");

#
# set the file buffer to 0
#
select("PIPE");
$| = 1;

foreach (1..100) {
	print PIPE "set samples 50\n";
	print PIPE "plot [-10:10] sin(x),cos(x)\n";

	print PIPE "set samples 50\n";
	print PIPE "plot [-10:10] sin(x/2),cos(x/2)\n";
}

$foo = <>;

close(PIPE);

