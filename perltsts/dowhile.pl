#!/usr/bin/env perl
#
# Test whether I can use a local variable in the test for w do while.
# I do not think so, since the while is a separate context from the do {} block.
#
use strict;
use warnings;

my $count = 0;
do {
    my $thisTest = 0;

    print "$count\n";
    if ($count++ > 10)
    {
        $thisTest = 1;
    }
} while ($thisTest == 0);
print "Done, $count\n";
exit (0);
