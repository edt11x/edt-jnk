#!/usr/bin/env perl
#
use strict;
use warnings;

my @a = qw( 1 2 3 4 5 6 7 8 9 10 );

sub testSub {
    print "The subroutine string is $_[0]\n";
}

for my $i (0 .. $#a) {
    print "The string            is $a[$i]\n";
    testSub($a[$i]);
}
exit 0;

