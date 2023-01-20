#! perl

use Getopt::Long;
use Pod::Usage;
use File::Basename;
use File::Compare;
use File::Copy;
use File::DirCompare;
use File::Find;
use File::Path;

use strict;
use warnings;

use constant {
    LOOKING_FOR_EOF => 'Looking For EOF',
    LOOKING_FOR_IDLES   => 'Finding Idles'
};

my $fromFile;
my $intoFile;
my $man     = 0;
my $help    = 0;
my $verbose = 0;
my $fromFileSize = 0;
my $intoFileSize = 0;
my $fromState = LOOKING_FOR_EOF;
my $intoState = LOOKING_FOR_EOF;
my $fromTell = 0;
my $intoTell = 0;
my $thisLine = "";
my $thatLine = "";
my $doneWithLoop = 0;
my $doneWithFromFile = 0;

GetOptions("help|?"  => \$help, 
    "man"     => \$man, 
    "verbose" => \$verbose,
    "from=s"  => \$fromFile, 
    "into=s"  => \$intoFile) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

my @args = glob "@ARGV";
if (@args) {
    if ($_) {
        foreach (@args) { print "Unexpected argument '$_'\n"; }
        pod2usage(3);
    }
}

if ((! $fromFile) || (! (-f "$fromFile"))) {
    pod2usage(-msg => "File you are merging from must exist.", -exitval => 4);
}

if ((! $intoFile) || (! (-f "$intoFile"))) {
    pod2usage(-msg => "File you are merging into, must exist.", -exitval => 5);
}

print "Figure out the size of the files\n" if $verbose;

$fromFileSize = -s $fromFile;
$intoFileSize = -s $intoFile;

print "$fromFile is $fromFileSize bytes long\n" if $verbose;
print "$intoFile is $intoFileSize bytes long\n" if $verbose;

($fromFileSize > 0) or die "From file size is zero, abort.";
($intoFileSize > 0) or die "Into file size is zero, abort.";

print "Open the files\n" if $verbose;

open RESULT, ">result.ptx" or die "Could not open result.ptx file : $!";
open FROM, "$fromFile" or die "Could not open file to merge from : $!";
open INTO, "$intoFile" or die "Could not open file to merge into : $!";

while (<INTO>)
{
    chomp;
    $thisLine = $_;
    if (($intoState eq LOOKING_FOR_EOF) && ($thisLine =~ /^EOF/)) 
    {
        print "We found our EOF, now we have to look for IDLEs\n" if $verbose;
        $intoState = LOOKING_FOR_IDLES;
        print RESULT $thisLine, "\n";
    }
    elsif ($intoState eq LOOKING_FOR_EOF)
    {
        print RESULT $thisLine, "\n";
    }
    elsif (($intoState eq LOOKING_FOR_IDLES) && ($thisLine =~ /^IDLE/))
    {
        print RESULT $thisLine, "\n";
    }
    elsif (($intoState eq LOOKING_FOR_IDLES) && ($thisLine =~ /^\s*$/))
    {
        print RESULT $thisLine, "\n";
    }
    elsif ($intoState eq LOOKING_FOR_IDLES)
    {
        print "The mixing point, where are we in the two files?\n" if $verbose;
        $fromTell = tell(FROM);
        $intoTell = tell(INTO);
        print "We are $fromTell bytes into $fromFile\n" if $verbose;
        print "We are $intoTell bytes into $intoFile\n" if $verbose;

        while ((($intoTell / $intoFileSize) > ($fromTell / $fromFileSize)) && (! $doneWithFromFile))
        {
            print "Mixing a packet in from $fromFile \n" if $verbose;
            if ($thatLine ne "")
            {
                print "Print the left overs from the last time we processed the from file\n" if $verbose;
                print RESULT $thatLine, "\n";
            }

            $fromState = LOOKING_FOR_EOF;
            $doneWithLoop = 0;
            while (! $doneWithLoop)
            {
                $thatLine = <FROM>;
                if (! defined($thatLine))
                {
                    print "Found the end of $fromFile\n" if $verbose;
                    $doneWithFromFile = 1;
                    $doneWithLoop = 1;
                }
                else
                {
                    chomp $thatLine;
                    if (($fromState eq LOOKING_FOR_EOF) && ($thatLine =~ /^EOF/))
                    {
                        print "We found our EOF, now we have to look for IDLEs\n" if $verbose;
                        $fromState = LOOKING_FOR_IDLES;
                        print RESULT $thatLine, "\n";
                    }
                    elsif ($fromState eq LOOKING_FOR_EOF)
                    {
                        print RESULT $thatLine, "\n";
                    }
                    elsif (($fromState eq LOOKING_FOR_IDLES) && ($thatLine =~ /^IDLE/))
                    {
                        print RESULT $thatLine, "\n";
                    }
                    elsif (($fromState eq LOOKING_FOR_IDLES) && ($thatLine =~ /^\s*$/))
                    {
                        print RESULT $thatLine, "\n";
                    }
                    elsif ($fromState eq LOOKING_FOR_IDLES)
                    {
                        $doneWithLoop = 1;
                    }
                    else
                    {
                        die "My state machine fell apart.";
                    }
                }
            }

            $fromTell = tell(FROM);
            $intoTell = tell(INTO);
            print "Checking where we are at again, where are we in the two files?\n" if $verbose;
            print "We are $fromTell bytes into $fromFile\n" if $verbose;
            print "We are $intoTell bytes into $intoFile\n" if $verbose;
        }
        print RESULT $thisLine, "\n";
        $intoState = LOOKING_FOR_EOF;
        print "Back to $intoFile, looking for an EOF\n" if $verbose;
    }
    else
    {
        die "My state machine fell apart.";
    }
}

if (! $doneWithFromFile)
{
    while (! $doneWithFromFile)
    {
        print "Mixing a packet in from $fromFile \n" if $verbose;
        if ($thatLine ne "")
        {
            print "Print the left overs from the last time we processed the from file\n" if $verbose;
            print RESULT $thatLine, "\n";
        }

        $fromState = LOOKING_FOR_EOF;
        $doneWithLoop = 0;
        while (! $doneWithLoop)
        {
            $thatLine = <FROM>;
            if (! defined($thatLine))
            {
                print "Found the end of $fromFile\n" if $verbose;
                $doneWithFromFile = 1;
                $doneWithLoop = 1;
            }
            else
            {
                chomp $thatLine;
                if (($fromState eq LOOKING_FOR_EOF) && ($thatLine =~ /^EOF/))
                {
                    print "We found our EOF, now we have to look for IDLEs\n" if $verbose;
                    $fromState = LOOKING_FOR_IDLES;
                    print RESULT $thatLine, "\n";
                }
                elsif ($fromState eq LOOKING_FOR_EOF)
                {
                    print RESULT $thatLine, "\n";
                }
                elsif (($fromState eq LOOKING_FOR_IDLES) && ($thatLine =~ /^IDLE/))
                {
                    print RESULT $thatLine, "\n";
                }
                elsif (($fromState eq LOOKING_FOR_IDLES) && ($thatLine =~ /^\s*$/))
                {
                    print RESULT $thatLine, "\n";
                }
                elsif ($fromState eq LOOKING_FOR_IDLES)
                {
                    $doneWithLoop = 1;
                }
                else
                {
                    die "My state machine fell apart.";
                }
            }
        }

        $fromTell = tell(FROM);
        $intoTell = tell(INTO);
        print "Checking where we are at again, where are we in the two files?\n" if $verbose;
        print "We are $fromTell bytes into $fromFile\n" if $verbose;
        print "We are $intoTell bytes into $intoFile\n" if $verbose;
    }
}

print "All done.\n" if $verbose;
close(FROM);
close(INTO);
close(RESULT);
exit (0);

__END__

=head1 NAME

mixor - mix one fcXplorer file into another

=head1 SYNOPSIS

mixor --from=ThisFile --into=ThatFile

    Options:
      --help        brief help message
      --man         manual page
      --verbose     tell about everything
      --from        the file to merge from
      --into        the file to merge into

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=item B<verbose>

More information will be printed.

=item B<from>

The file to merge data from

=item B<into>

The file to merge data into

=back

=head1 DESCRIPTION

This program mixes one fcXplorer scenario file into another.

=cut

