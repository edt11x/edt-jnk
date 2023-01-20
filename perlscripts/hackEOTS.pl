#! perl
#

use strict;
use warnings;

open FILE, "q:/ptxFiles/EOTS.ptx" or die "No file.";

my $fileCount = 1;
my $thisFileName = "";
my $fileOpen = 0;

while (<FILE>)
{
    chomp;
    my $thisLine = $_;
    if ($thisLine =~ /(0x\S{8}) ; .* Pix Count (\d+)/)
    {
        my $value = $1;
        my $count = $2;

        if ($count == 4)
        {
            print "Begin line $thisLine\n";
            $thisFileName = "c:/tmp/EOTS_" . sprintf("%04d", $fileCount) . ".raw";
            open OUT, ">" . $thisFileName or die "No output file $!";
            $fileOpen = 1;
        }
        if ($fileOpen)
        {
            syswrite(OUT, pack("L", hex $value), 4);
        }
        if ($count == 409600)
        {
            print "Last line $thisLine\n";
            if ($fileOpen)
            {
                close OUT;
                $fileOpen = 0;
                exit 0;
            }
        }
    }
}

close FILE;
exit 0;
