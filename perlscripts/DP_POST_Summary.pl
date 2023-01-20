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
use Scalar::MoreUtils qw(default);

my %monList = ( "Jan" => 0, "Feb" => 1, "Mar" => 2, "Apr" => 3, "May" => 4, "Jun" => 5, "Jul" => 6, "Aug" => 7, "Sep" => 8, "Oct" => 9, "Nov" => 10, "Dec" => 11 );

my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub parseFile {
    my $fileName = $_[0];
    my $essFile = $_[1];
    open FILE, "$fileName" or die "Could not open file : $!\n";
    my %postTestSummary = ();
    my $foundAllSystemsGo = 0;
    my %restartCount = ();
    my $powerCycle = 0;

    while(<FILE>) {
        chomp;
        my $dpLine = $_;
        if (/All systems go/) {
            $foundAllSystemsGo = 1;
            $powerCycle = 0;
            my ($weekDay, $mon, $day, $hr, $min, $sec, $frac, $year) =
                $_ =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
            my $dpTime = timelocal($sec, $min, $hr, $day, $monList{$mon}, $year) + $frac / 1000.0;
            open SPFILE, "$essFile" or die "Could not open SP file : $!\n";
            while (<SPFILE>) {
                chomp;
                if (/^\[(\w\w\w \w\w\w \d\d \d\d:\d\d:\d\d\.\d\d\d \d\d\d\d)\]\s+\*\s+EBL Formal/) { # found a boot
                    ($weekDay, $mon, $day, $hr, $min, $sec, $frac, $year) =
                        $_ =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
                    my $spLine = $_;
                    my $spTime = timelocal($sec, $min, $hr, $day, $monList{$mon}, $year) + $frac / 1000.0;
                    if (abs($dpTime - $spTime) < 12) {
                        $powerCycle = 1;
                        print "Found a power cycle\n";
                        print "  -- $dpLine\n";
                        print "  -- $spLine\n";
                    }
                }
            }
            close SPFILE;
            $restartCount{$powerCycle} = default($restartCount{$powerCycle}, 0) + 1;
        }
        if (($foundAllSystemsGo) && ($dpLine =~ /POST (\d\d): (PASSED|FAILED): (.*)/)) {
            my $testNumber = $1 + 0;
            my $result     = $2;
            my $msg        = $3;
            $postTestSummary{$powerCycle}{$testNumber}{Result} = $result;
            $postTestSummary{$powerCycle}{$testNumber}{Message} = $msg;
            if (defined($postTestSummary{$powerCycle}{$testNumber}{Count})) {
                $postTestSummary{$powerCycle}{$testNumber}{Count}++;
            } else {
                $postTestSummary{$powerCycle}{$testNumber}{Count} = 1;
            }
            if ($result =~ /PASSED/) {
                if (defined($postTestSummary{$powerCycle}{$testNumber}{Passed})) {
                    $postTestSummary{$powerCycle}{$testNumber}{Passed}++;
                } else {
                    $postTestSummary{$powerCycle}{$testNumber}{Passed} = 1;
                }
            }
            if ($result =~ /FAILED/) {
                if (defined($postTestSummary{$powerCycle}{$testNumber}{Failed})) {
                    $postTestSummary{$powerCycle}{$testNumber}{Failed}++;
                } else {
                    $postTestSummary{$powerCycle}{$testNumber}{Failed} = 1;
                }
            }
        }
    }
    close(FILE);
    for $powerCycle (1, 0) {
        if ($powerCycle) {
            print "Full Power Cycle Results\n";
        } else {
            print "VP Power Cycle Results\n";
        }
        for my $testNumber (sort { $a <=> $b } (keys %{ $postTestSummary{$powerCycle} })) {
            printf("POST %02d, %s Passed %8.4f, Failed %8.4f, Count %d\n",
                $testNumber,
                substr($postTestSummary{$powerCycle}{$testNumber}{Message} . "," . (" " x 25), 0, 25),
                default($postTestSummary{$powerCycle}{$testNumber}{Passed},0) / $restartCount{$powerCycle},
                default($postTestSummary{$powerCycle}{$testNumber}{Failed},0) / $restartCount{$powerCycle},
                default($postTestSummary{$powerCycle}{$testNumber}{Passed},0) + 
                default($postTestSummary{$powerCycle}{$testNumber}{Failed},0));
        }
    }
}

&parseFile(@ARGV);

exit 0;

__END__

=head1 NAME

DP_POST_Summary.pl - Summarize DP POST Errors across a run

=head1 SYNOPSIS

DP_POST_Summary.pl 

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

This function digests the logs.

=cut


