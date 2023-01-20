#! perl
#
use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';

use Getopt::Std;
use Win32::Autoglob;

sub parseFile {
    my ($thisFile) = @_;

    open(FILE, "$thisFile") || die("Could not open $thisFile : $!");
    binmode(FILE);

    my $buffer = '';
    my $done = 0;
    my $count = 0;

    while ((! $done) && ( sysread(FILE, $buffer, 4) ))
    {
        my $value = unpack 'N', $buffer;
        if ($count == 0) # brute force
        {
            print "Rockwell Collins RCHEADER\n";
            printf "CRC  : 0x%08X\n", $value;
        }
        elsif ($count == 1)
        {
            printf "Size : 0x%08X\n", $value;
        }
        else
        {
            printf "CPN  : 0x%08X\n", $value;
            $done = 1;
        }
        $count++;
    }
    close(FILE);
}

defined($ARGV[0]) || die("Must have a file name to dump the KDI or Rockwell Collins Header.\n");

foreach my $arg (@ARGV)
{
    print "Parsing $arg\n";
    &parseFile($arg);
}
exit(0);

