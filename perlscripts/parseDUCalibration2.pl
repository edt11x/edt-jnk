#! perl
# My generic template for parsing a file

use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;
use File::Glob ':glob';
use Win32::Autoglob;
use Scalar::MoreUtils qw( empty );

my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;
my %xVals;
my %yVals;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub parseLine {
    my $thisLine = $_[0];
    if ((! empty($thisLine)) && ($thisLine =~ /\[([xy])\]\[(\d\d)\]=\s.*\smean=\s*([\d\.%]+)/)) {
        # print "Here - $thisLine \n";
        my $chart = $1;
        my $intVal = $2;
        my $value = $3;
        # print "Chart - $chart, IntVal - $intVal, value - $value\n";
        (my $new = $value) =~ s|(\d+\.?\d*)%|$1/100|eg;
        $xVals{$intVal} = $new if ($chart eq "x");
        $yVals{$intVal} = $new if ($chart eq "y");
    }
}

sub parseFile {
    my $fileName = $_[0];
    open FILE, "$fileName" or die "Could not open file : $!\n";
    my $thowingAwayInitialLines = 1;
    my $joiningLines = 0;
    my $thisLine;

    while(<FILE>) {
        chomp;
        # throw away everything until we start seeing calibration lines
        if (($thowingAwayInitialLines) && (/\[[xy]\]\[\d\d\]/)) {
            $thowingAwayInitialLines = 0;
        } elsif (! $thowingAwayInitialLines) {
            if (/\[[xy]\]\[\d\d\]/) {
                # print "\n", $thisLine, "\n" if (! empty($thisLine));
                parseLine($thisLine);
                $joiningLines = 1;
                $thisLine = $_;
            } elsif ($joiningLines) {
                $thisLine .= $_;
                if (/\)$/) {
                    $joiningLines = 0;
                }
            }
        }
    }
    # print $thisLine, "\n" if (! empty($thisLine));
    parseLine($thisLine);
    close(FILE);
    for my $xVal (sort {$a<=>$b} keys %xVals) {
        print " , ", $xVal;
    }
    print "\n";
    for my $yVal (sort {$a<=>$b} keys %yVals) {
        print $yVal;
        for my $xVal (sort {$a<=>$b} keys %xVals) {
            print " , ", $xVals{$xVal} * $yVals{$yVal};
        }
        print "\n";
    }
    print "\n";
}

foreach my $arg (@ARGV)
{
    if (-e ($arg))
    {
        print "Parsing File : $arg\n\n";
        &parseFile($arg);
    }
}

exit 0;

__END__

=head1 NAME

parseDUCalibration.pl - Parse the DU calibration logs

=head1 SYNOPSIS

parseDUCalibration.pl 

    Options:
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=back

=head1 DESCRIPTION

This function parses the DU calibration logs.

=cut

