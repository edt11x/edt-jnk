#! perl

use strict;
use warnings;

my $INCREMENT = 0x00100000;
my $NVRAMSIZE = 128 * 1024;

open FILE, ">dumpLeft.mbs" or die "Could not open output file : $!";

for (my $addr = 0xe0000000; $addr < 0xf0000000; $addr += $INCREMENT)
{
    printf FILE "memdump raw Dump_Left_0x%08X.bin 0x%08X 0x%08X\n", $addr, $addr, $INCREMENT;
}
printf FILE "memdump raw Dump_Left_NVRAM.bin 0xf0800000 0x%08X\n", $NVRAMSIZE;
close(FILE);

open FILE, ">dumpRight.mbs" or die "Could not open output file : $!";

for (my $addr = 0xe0000000; $addr < 0xf0000000; $addr += $INCREMENT)
{
    printf FILE "memdump raw Dump_Right_0x%08X.bin 0x%08X 0x%08X\n", $addr, $addr, $INCREMENT;
}
printf FILE "memdump raw Dump_Right_NVRAM.bin 0xf0800000 0x%08X\n", $NVRAMSIZE;
close(FILE);
exit 0;

