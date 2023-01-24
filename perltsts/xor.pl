#!/usr/bin/env perl
#
# Generate memory pattern XORs
#
use strict;
use warnings;

my $word1 = 0x55AAFF55;
my $word2 = 0xAAFF55AA;
my $word3 = 0xFF55AAFF;

printf("0x%08X 0x%08X 0x%08X\n", $word1, $word2, $word3);
$word1 = ($word1 ^ 0xAAFF55AA);
$word2 = ($word2 ^ 0xFF55AAFF);
$word3 = ($word3 ^ 0x55AAFF55);
printf("0x%08X 0x%08X 0x%08X\n", $word1, $word2, $word3);
$word1 = ($word1 ^ 0x55AAFF55);
$word2 = ($word2 ^ 0xAAFF55AA);
$word3 = ($word3 ^ 0xFF55AAFF);
printf("0x%08X 0x%08X 0x%08X\n", $word1, $word2, $word3);
exit 0;
