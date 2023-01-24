#! perl
#
use strict;
use warnings;

sub rtrim {
    ## remove trailing spaces
    $_[0] =~ s/\s+$//;
}

my $thisStr = "abcd      ";
my $strLen  = length($thisStr);

print $thisStr, " is ", $strLen, "\n";

rtrim($thisStr);
print $thisStr, " is ", length($thisStr), "\n";

if ($strLen != length($thisStr))
{
    print "ACK!!!! the length of the strings has changed\n";
}
exit 0;

