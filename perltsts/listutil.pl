#! perl
#
use strict;
use warnings;

use List::Util;

my @arr1 = ( 1 .. 20, 25, 3, 9 );
my @arr2;

print "Max value ", List::Util::max(@arr1), " Min value ", List::Util::min(@arr1), "\n";

my $min = List::Util::min(@arr2);
my $max = List::Util::max(@arr2);
my $maxint = int($max);

if (!defined($min))
{
    print "Min arr2 worked as expected\n";
}

if (!defined($max))
{
    print "Max arr2 worked as expected\n";
}

if (!defined($maxint))
{
    print "Max Int arr2 worked as expected\n";
}

exit 0;

