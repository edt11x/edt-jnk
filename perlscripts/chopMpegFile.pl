#! perl

use Getopt::Std;

use strict;

sub chopMpegFile
{
    my ($fileName) = @_;

    open FILE, "$fileName" or die "Could not open file: $!\n";
    open OUT,  ">out.mpg"   or die "Could not open file: $!\n";

    binmode(FILE);
    binmode(OUT);

    my $buffer = '';
    my $count  = 0;
    my $done   = 0;

    while ((! $done) && ( sysread(FILE, $buffer, 4) ))
    {
        my $value = unpack 'N', $buffer;
        if (($count++ > 2 * 1024 * 1024) && ($value == 0x000001b3))
        {
            print "Closing file.\n";
            $done = 1;
        }
        else
        {
            syswrite(OUT, $buffer, 4);
        }
        if (($count % (1024*100)) == 0)
        {
            print "Count $count\n";
        }
    }
    close(FILE);
    close(OUT);
}


my @args = splice(@ARGV, 0);
foreach my $arg (@args)
{
    print "$arg\n";
    &chopMpegFile($arg);
}
