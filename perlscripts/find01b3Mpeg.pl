#! perl
use Getopt::Std;
use strict;
use warnings;

sub chopMpegFile {
    my ($fileName) = @_;

    open FILE, "$fileName" or die "Could not open file: $!\n";
    open OUT,  ">$fileName.out.mpg" or die "Could not open file: $!\n";

    binmode(FILE);
    binmode(OUT);

    my $buffer = '';
    my ($count, $done) = (0, 0);

    while ((! $done) && ( sysread(FILE, $buffer, 4) )) {
        if ((unpack 'N', $buffer) == 0x000001b3) { # throw everything away until 1b3
            syswrite(OUT, $buffer, 4);
            $done = 1;
        }
    }

    while ( sysread(FILE, $buffer, 4) ) {
        $count += syswrite(OUT, $buffer, 4);
        if (($count % 100000) == 0) {
            print "Count $count\n";
        }
    }
    close(FILE);
    close(OUT);
}

foreach my $arg (splice(@ARGV, 0)) {
    &chopMpegFile($arg);
}
