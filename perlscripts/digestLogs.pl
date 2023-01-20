#! perl

use strict;
use warnings;

use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;

my $LogFileRepository = "P:/edt/logfiles/mergedLogRepository/Log Files";
my $DigestRepository  = "J:/ESS/EU Logs";
my $FifteenMinutes = 60 * 15;
my $minLogSize = 100000;
my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;

my %monthList = ( "Jan" => 0, "Feb" => 1, "Mar" => 2, "Apr" => 3, "May" => 4, "Jun" => 5, "Jul" => 6, "Aug" => 7, "Sep" => 8, "Oct" => 9, "Nov" => 10, "Dec" => 11 );

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

# Get a list of the files
opendir(DIR, $LogFileRepository) or die $!;
my @files1 = readdir(DIR) or die $!;
my @files = ();
closedir(DIR);

foreach my $file (@files1) {
    if ($file =~ /^(\d\d\d\d) (\d\d\d\d)-(\d\d)-(\d\d) (\d\d)\.(\d\d) JSF EU ESS.txt$/) {
        my $unit  = $1;
        my $year  = $2;
        my $month = $3;
        my $day   = $4;
        my $hour  = $5;
        my $min   = $6;
        # Get the file information, specifically last modified date
        my @fileData = stat($LogFileRepository . "/" . $file) or die $!;
        $file = $fileData[9] . "&&" . $file;
        push(@files, $file);
    }
}

@files = reverse(sort(@files));
# now we have the list of log files in date order, most recent first

foreach my $entry (@files) {
    my ($date, $file) = split(/\&\&/, $entry);
    my $fullpath = $LogFileRepository . "/" . $file;
    my $filesize = (-s $fullpath);
    $file =~ /^(\d\d\d\d) (\d\d\d\d)-(\d\d)-(\d\d) (\d\d)\.(\d\d) JSF EU ESS.txt$/;
    my $unit  = $1;
    my $year  = $2;
    my $month = $3;
    my $day   = $4;
    my $hour  = $5;
    my $min   = $6;
    my $ans   = "";

    if ($filesize > $minLogSize) {
        print "$date -- $file -- $filesize\n";
        my $dir = $DigestRepository . "/SN " . $unit . "/" . $year . "-" . $month . "-" . $day;
        if ((defined($yesToAllFiles)) && ($yesToAllFiles != 0)) {
            print "Processing $file\n";
            $ans = "y";
        } else {
            print "This one?";
            $ans = <>;
            chomp $ans;
        }
        if ($ans eq "y") {
            mkpath($dir);
            copy($fullpath, $dir . "/" . $file);
            system("perl r:/tools/edt/essTemperaturesToCSV.pl --directory=\"$dir\" \"$file\"");
            # now I have to find the TeraTerm logs
            # TeraTerm log could have started a week or more before, but no more than a couple 
            # days after.
            #
            # Get the time stamp given the date encoded in the filename
            my $timestamp = timelocal(0, $min, $hour, $day, $month-1, $year);
            # print "Search timestamp - $timestamp - ", scalar localtime $timestamp, "\n";
            my $lowLimit = $timestamp - 1 * 7 * 24 * 60 * 60;
            my $highLimit = $timestamp + 3 * 24 * 60 * 60;
            # roll through the file list again.
            foreach my $ttFile (sort(@files1)) {
                if ($ttFile =~ /^TeraTerm-SP-(Right|Left)-(\d\d\d\d)-(\d\d)-(\d\d)-(\d\d)(\d\d)(\d\d)\.log$/) {
                    my $leftRight = $1;
                    my $ttYear = $2;
                    my $ttMonth = $3;
                    my $ttDay = $4;
                    my $ttHour = $5;
                    my $ttMin = $6;
                    my $ttSec = $7;
                    my $ttTimeStamp = timelocal($ttSec, $ttMin, $ttHour, $ttDay, $ttMonth-1, $ttYear);
                    # need to do this step just to reduce the possibilities
                    if (($ttTimeStamp > $lowLimit) && ($ttTimeStamp <= $highLimit)) {
                        print "Evaluating $ttFile\n";
                        my $ttPath = $LogFileRepository . "/" . $ttFile;
                        open my $fh, $ttPath or die "Could not open $ttPath: $!";
                        my @lines = grep /EU Under Test .* : $unit/, <$fh>;
                        close($fh);
                        if (@lines) {
                            # So now we want to look at these lines and find a timestamp that is 
                            # within about 15 minutes of that time.
                            for my $line (@lines) {
                                if ($line =~ /\[(\w\w\w) (\w\w\w) (\d+) (\d+):(\d+):(\d+)\.(\d+) (\d+)\]/) {
                                    my $lineDayName = $1;
                                    my $lineMonth = $2;
                                    my $lineDay = $3;
                                    my $lineHour = $4;
                                    my $lineMin = $5;
                                    my $lineSec = $6;
                                    my $lineFract = $7;
                                    my $lineYear = $8;
                                    my $lineTimeStamp = timelocal($lineSec, $lineMin, $lineHour, $lineDay, $monthList{$lineMonth}, $lineYear);
                                    if (abs($timestamp - $lineTimeStamp) < $FifteenMinutes) {
                                        print "Match $file to time stamp $line, file $ttFile\n";
                                        copy($ttPath, $dir . "/" . $ttFile);
                                        last;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

exit 0;

__END__

=head1 NAME

digestLogs.pl - digest the logs from the merged log repository

=head1 SYNOPSIS

digestLogs.pl 

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

