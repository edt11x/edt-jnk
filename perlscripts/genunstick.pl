#!perl
#
use strict;
use warnings;

my $NUM_UNSTICKS = 64;

open FILE, ">unstick.cmd" or die("No unstick.cmd");

for (my $i = 0; $i < $NUM_UNSTICKS; $i++)
{
    print FILE "\@echo.\n";
    print FILE "\@echo Unstick # " . ($i + 1) . " of $NUM_UNSTICKS\n";
    print FILE "fcio -u\n";
}
close FILE;
print "unstick.cmd generated\n";

exit 0;

