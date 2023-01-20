#! perl
use strict;
use warnings;
defined($ARGV[0]) || die("Must have target sum. Example, 12 for 12 hours.\n");
my $sum = -1;
my $target = int($ARGV[0]);
while ($sum != $target) {
    my $x = int(rand($target+1));
    my $y = int(rand($target+1));
    my $z = int(rand($target+1));
    $sum = $x + $y + $z;
    print "$x $y $z\n" if ($sum == $target);
}
