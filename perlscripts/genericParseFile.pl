#! perl

use Getopt::Std;

use strict;

# binary file example
sub chopMpegFile
{
    my ($fileName) = @_;

    open FILE, "$fileName" or die "Could not open file: $!\n";
    open OUT,  ">out.mpg"   or die "Could not open file: $!\n";

    binmode(FILE);
    binmode(OUT);

    my $buffer = '';
    my $count  = 0;
    my $done   = 0;

    while ((! $done) && ( sysread(FILE, $buffer, 4) ))
    {
        my $value = unpack 'N', $buffer;
        if (($count++ > 2 * 1024 * 1024) && ($value == 0x000001b3))
        {
            print "Closing file.\n";
            $done = 1;
        }
        else
        {
            syswrite(OUT, $buffer, 4);
        }
        if (($count % (1024*100)) == 0)
        {
            print "Count $count\n";
        }
    }
    close(FILE);
    close(OUT);
}

# regular text file
sub parseFile {
my ($thisFile)    = @_;
my $lineCount     = 0;
my @pieces        = ();

    open(FILE, "$thisFile") || die("no file $thisFile");
    while (<FILE>) {
        @pieces      = split(',', $_);
        print @pieces, "\n";
    }
    close(FILE);
}


my @args = splice(@ARGV, 0);
foreach my $arg (@args)
{
    print "$arg\n";
    &parseFile($arg);
}
