#!/usr/bin/env perl
#
use strict;
use warnings;

print "(";
foreach my $i (1950 .. 1979) {
    print $i;
    print "|" if ($i < 1979);
}
print ") cadillac\n";

