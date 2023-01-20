#! perl -w

use Getopt::Std;

use strict;
use warnings;

my $sn = "2023";
my $side = "left";

sub parseFile
{
    my ($fileName) = @_;
    my $thisLine   = '';
    my $thisTime   = 0.0;
    my %coords;

    open FILE, "$fileName" or die "Could not open file : $!\n";

    while (<FILE>)
    {
        if (defined($_))
        {
            $thisLine = $_;
            # Only two types of lines, I am interested in. Time stamps and touches
            if ($thisLine =~ /^DU-> EU  /)
            {
                ($thisTime) = /^DU-> EU\s+([\d\.]+)/ or die "Syntax error: $_";
            }
            if ($thisLine =~ /^Touch det = /)
            {
                my ($det, $valid, $x, $y) = /^Touch det = 0x([0-9a-fA-F]+) err = 0x([0-9a-fA-F]+) x = (\d+) y = (\d+)/ or die "Syntax error: $_";
                $det   = hex($det);
                $valid = hex($valid);
                $x = $x + 0;
                $y = $y + 0;
                print $sn, ",", $side, ",", $thisTime, ",", $det, ",", $valid, ",", int($x), ",", int($y), "\n";
                if (($valid != 0) && (($det == 1) || ($det == 2) || ($det == 3)))
                {
                    # Count the coordinate pairs
                    if (defined($coords{$x}{$y}))
                    {
                        $coords{$x}{$y} += 1;
                    }
                    else
                    {
                        $coords{$x}{$y} = 1;
                    }
                }
            }
        }
    }
    close(FILE);

    for (my $i = 0; $i < 400; $i++)
    {
        for (my $j = 0; $j < 400; $j++)
        {
            if (defined($coords{$i}{$j}))
            {
                print "x = $i, y = $j, count = ", $coords{$i}{$j}, "\n";
            }
        }
    }
}



my @args = splice(@ARGV, 0);

foreach my $arg (@args)
{
    &parseFile($arg);
}
