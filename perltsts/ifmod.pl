#! perl
#
use strict;
use warnings;

my $a = 3;
my $b = 9;

my $condition = 1;

$a = 14 if defined($condition);
$b = 12 if $condition;

print "a = $a\n";
print "b = $b\n";

$a = 3;
$b = 9;

$a = 14 if !defined($condition);
$b = 12 if !$condition;

print "a = $a\n";
print "b = $b\n";
exit 0;
