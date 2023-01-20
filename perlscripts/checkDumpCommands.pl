#! perl

use strict;
use warnings;

my $INCREMENT = 0x00100000;
my $NVRAMSIZE = 128 * 1024;

foreach my $side ("Left", "Right")
{
    print "Checking $side\n";
    for (my $addr = 0xe0000000; $addr < 0xf0000000; $addr += $INCREMENT)
    {
        my $fileName = sprintf "Dump_%s_0x%08X.bin", $side, $addr;
        if (! -e "$fileName")
        {
            print "Ack! $fileName does not exist\n";
        }
        my $fileSize = -s "$fileName";
        if ($fileSize != (1024 * 1024))
        {
            print "Ack! $fileName is not 1 Mbyte\n";
        }
    }
}
print "Done.\n";

exit 0;

