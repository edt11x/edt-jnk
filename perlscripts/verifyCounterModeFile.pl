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
    my $done   = 0;
    my $firstTime = 0;
    my $lastValue = 0;
    my $location  = 0;

    while ((! $done) && ( sysread(FILE, $buffer, 4) ))
    {
        my $value = unpack 'N', $buffer;
        if ($firstTime == 0)
        {
            if ($value != 0x1b3)
            {
                print "First value was not 0x1b3, abort!\n";
                exit(1);
            }
            $firstTime = 1;
        }
        else
        {
            if ($value != ($lastValue + 1))
            {
                printf("Value mismatch at location 0x%08X, expected 0x%08X, read 0x%08X\n",
                    $location, $lastValue + 1, $value);
            }
        }
        $location++;
        $lastValue = $value;

        if (($location % (1024*100)) == 0)
        {
            print "Location $location\n";
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
