#!/usr/bin/perl -w
use Getopt::Long;
use File::Find;

sub generateFile {
my($thisFile) = @_;

    open(OUT, ">$thisFile") || die("Can't open $thisFile ");
    for ($i = 0; $i < $fs; $i++)
    {
        syswrite(OUT, pack("L", 0xFFFFFFFF), 1);
    }
    close(OUT);
}

$fs = 4;
GetOptions('f=i', \$fs);

defined($ARGV[0]) || die("Must have a file name for generating an empty file full of FFs.\n");

@fileList = glob "@ARGV";

# foreach file
foreach (@fileList) {
    &generateFile($_);
}
