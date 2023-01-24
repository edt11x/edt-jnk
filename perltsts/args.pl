#!/usr/bin/env perl
use strict;
use warnings;

print "Number of arguments to this program : " . scalar(@ARGV) . "\n";
print "-- " . $_ . "\n" for (@ARGV);

