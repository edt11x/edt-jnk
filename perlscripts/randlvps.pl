#!/usr/bin/env perl -w
use strict;

my $volt1 = 19.9 + int(rand(110)) / 10.0;
my $volt2 = 19.9 + int(rand(110)) / 10.0;
my $volt3 = 19.9 + int(rand(110)) / 10.0;
my $volt4 = 19.9 + int(rand(110)) / 10.0;

print "Left  A " . $volt1 . " volts\n";
print "Left  B " . $volt2 . " volts\n";
print "Right A " . $volt3 . " volts\n";
print "Right B " . $volt4 . " volts\n";

exit 0;
