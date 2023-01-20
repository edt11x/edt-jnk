#!/usr/bin/env perl

use strict;
use warnings;

my $fileToParse = 'P:\edt\logfiles\EUMTE3\2015-03-03\Log Files\TeraTerm-DP-Left-2015-02-27-190119.log';
my $count = 0;
my $hw = qr/[\da-f]{8}/;
my $lastIdx = 0;
my $goodResult = "...._...._...._...._...._...._...._....";
my @arr = ();

$arr[$_] = $goodResult for (0..3);
open FILE, $fileToParse or die "Can not open file : $!";
while (<FILE>) {
    chomp;
    if (/TF${hw}_(${hw})\(${hw}!=${hw}\) (.*)/) {
        my $idx = (hex($1) & 0xf) / 4;
        my $res = $2;
        if (($count > 0) && ($idx <= $lastIdx)) {
            for my $i (0..3) {
                print $arr[3-$i];
                print " " if $i < 3;
            }
            print "\n";
            $arr[$_] = $goodResult for (0..3);
        }
        $arr[$idx] = $res;
        $lastIdx = $idx
    }
    $count++;
}
close FILE;
exit 0;
