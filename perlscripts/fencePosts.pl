#!/usr/bin/env perl
#
use strict;
use warnings;

my $postNum = 1;
open(FILE, "otp_types_partial.h") || die "No File : $!";
while (<FILE>) {
    print $_;
    if ($postNum < 190) {
        print "    UINT32 fencePost",$postNum++,";\r\n";
    }
}
close(FILE);

