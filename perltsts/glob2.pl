#! perl

use Getopt::Long;
use File::Glob ':glob';

use strict;
use warnings;

foreach my $arg (@ARGV)
{
    # glob each argument
    if ((defined($arg)) && ($arg ne ""))
    {
        my @list = bsd_glob($arg);
        foreach my $thisOne (@list)
        {
            if ((defined($thisOne)) && ($thisOne ne ""))
            {
                print "parseFile($thisOne)\n";
            }
        }
    }
}

