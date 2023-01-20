#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;


# my @set = ('0' .. '9', 'A' .. 'Z', 'a' .. 'z');
# non ambiguous characters
# https://ux.stackexchange.com/questions/21076/are-there-numbers-and-letters-to-avoid-for-activation-codes-via-sms
my @set = split //,'abcdefghkmnoprstwxzABCDEFGHJKLMNPQRTWXY34689';
my $pwLen = 63;
GetOptions('long=i' => \$pwLen);
if ($pwLen < 1) {
    $pwLen = 63;
}
my $passwd = join '' => map $set[rand @set], 1 .. $pwLen;
print "$passwd\n";

exit 0;
