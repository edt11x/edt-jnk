#!/usr/bin/env perl
#
use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/jnk/perlmodules';
use Cwd 'realpath';

use Getopt::Long;
use Scalar::MoreUtils qw( empty );
use Pod::Usage;
use Time::Local;

# Floating Point Number Regular Expression
my $floatingNumberRegEx = qr/[-+]?[0-9]*\.?[0-9]+/;
# Temperature Regular Expression
# What does a temperature look like in OTP Output?
# -20, -20.9, 30, 34.0
my $temperatureRegEx = $floatingNumberRegEx;
# Cycle Count Regular Expression.
# The leading part of the summary line contains the test count, test failures,
# wall or chamber time, temperature and then left or right.
# For example,
#     63    4 22:00:22 Amb Left
#                            $1      $2      $3                 $4
my $cycleCountRegEx = qr/^\s*(\d+)\s+(\d+)\s+(\d\d:\d\d:\d\d)\s+(${temperatureRegEx}|Amb)/;
my $log;
my $spleft;
my $spright;
my $dpleft;
my $dpright;
my $state;
my $nextBlock;
my $currentTime;
my $currentHMS;
my $powerOnTime;
my $essBlockTime;
my $essBlockHMS;

use constant {
    FIND_POWER_CYCLE   => 0,
    FIND_LEFT_LINE     => 1,
    PRINT_ESS_BLOCK    => 2,
    PRINTING_ESS_BLOCK => 3,
    FOUND_NEXT_BLOCK   => 4
};

sub parseHMS {
    my $hms = $_[0];
    $hms =~ /(\d\d):(\d\d):(\d\d)/;
    return timegm($3, $2, $1, 1, 0, 1970);
}

sub updateCurrentTime {
    my $previous = $_[0];
    my $current = $_[1];
    my $startTime = $_[2];
    if ($current >= $previous) {
        $startTime += $current - $previous;
    } else {
        $startTime += 24 * 60 * 60 + $current - $previous;
    }
    return $startTime;
}

sub updateCurrentHMS {
    my $previous = $_[0];
    my $current = $_[1];
    my $startTime = $_[2];
    $startTime = updateCurrentTime($previous, $current, $startTime);
    if ($startTime > 24 * 60 * 60) {
        $startTime -= 24 * 60 * 60;
    }
    return $startTime;
}

sub printLocalTime {
    if (defined($_[0])) {
        my ($sec,$min,$hour,$day,$mon,$year) = localtime($_[0]);
        printf("%02d/%02d/%04d %02d:%02d:%02d\n",
            $mon+1, $day, $year+1900, $hour, $min, $sec);
    }
}

sub printBlockSep {
    my $title = $_[0];
    print "\n";
    print "======================================================\n";
    print "======================================================\n";
    print "$title\n";
    print "======================================================\n";
    print "======================================================\n";
}


my %monList = ( "Jan" => 0, "Feb" => 1, "Mar" => 2, "Apr" => 3, "May" => 4, "Jun" => 5, "Jul" => 6, "Aug" => 7, "Sep" => 8, "Oct" => 9, "Nov" => 10, "Dec" => 11 );

GetOptions ( "log=s"     => \$log,
             "spleft=s"  => \$spleft,
             "spright=s" => \$spright,
             "dpleft=s"  => \$dpleft,
             "dpright=s" => \$dpright)
             or pod2usage(1);

pod2usage(1) if (empty($log) || empty($spleft) || empty($spright));

open LOG,     "$log"     or pod2usage(-msg => "Must specify the ESS log file.",      -exitval => 1);
open SPLEFT,  "$spleft"  or pod2usage(-msg => "Must specify the SP Left log file.",  -exitval => 1);
open SPRIGHT, "$spright" or pod2usage(-msg => "Must specify the SP Right log file.", -exitval => 1);
open DPLEFT,  "$dpleft"  if (! empty($dpleft));
open DPRIGHT, "$dpright" if (! empty($dpright));

$state = FIND_POWER_CYCLE;
my $count = 0;
while (my $logLine = <LOG>) {
    chomp $logLine;
    my $thisLine = $logLine;
    if (($state == FIND_POWER_CYCLE) && 
        ($thisLine =~ /^Power Cycle - (\d+)\/(\d+)\/(\d\d\d\d) (\d+):(\d\d) ([AP]M)/)) {
        my $mon = $1;
        my $day = $2;
        my $year = $3;
        my $hour = $4;
        my $min = $5;
        my $am_pm = $6;
        $hour -= 12 if ($am_pm eq 'AM' && $hour == 12);
        $hour += 12 if ($am_pm eq 'PM' && $hour != 12);
        $powerOnTime = timelocal(0, $min, $hour, $day, $mon-1, $year);
        $currentTime = $powerOnTime;
        $currentHMS = timegm(0, $min, $hour, 1, 0, 1970);
        print $thisLine,"\n";
        $state = FIND_LEFT_LINE;
    }
    if (($state == FIND_LEFT_LINE) && 
        ($thisLine =~ /${cycleCountRegEx}\s*(Left)\s+/)) { # Left header line
        $essBlockTime = $3;
        $essBlockHMS = parseHMS($essBlockTime);
        $currentTime = updateCurrentTime($currentHMS, $essBlockHMS, $currentTime);
        $currentHMS = updateCurrentHMS($currentHMS, $essBlockHMS, $currentHMS);
        printLocalTime($currentTime);
        $state = PRINT_ESS_BLOCK;
    }
    if (($state == PRINT_ESS_BLOCK) || ($state == PRINTING_ESS_BLOCK)) {
        if (($state == PRINTING_ESS_BLOCK) &&
            ($thisLine =~ /${cycleCountRegEx}\s*(Left)\s+/)) { # Left header line
            $nextBlock = $thisLine;
            $state = FOUND_NEXT_BLOCK;
        } else {
            print $thisLine, "\n";
            $state = PRINTING_ESS_BLOCK;
        }
    }
    if ($state == FOUND_NEXT_BLOCK) {
        printBlockSep("SP Left");
        my $thisTime = 0;
        while (defined(my $spLeftLine = <SPLEFT>) && ($thisTime < $currentTime)) {
            chomp $spLeftLine;
            if (! empty($spLeftLine)) {
                print "SP Left  - ", $spLeftLine, "\n";
                my ($l_weekDay, $l_mon, $l_day, $l_hr, $l_min, $l_sec, $l_frac, $l_year) =
                    $spLeftLine =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
                $thisTime = timelocal($l_sec, $l_min, $l_hr, $l_day, $monList{$l_mon}, $l_year) + $l_frac / 1000.0;
            }
        }
        printBlockSep("SP Right");
        $thisTime = 0;
        while (defined(my $spRightLine = <SPRIGHT>) && ($thisTime < $currentTime)) {
            chomp $spRightLine;
            if (! empty($spRightLine)) {
                print "SP Right - ", $spRightLine, "\n";
                my ($l_weekDay, $l_mon, $l_day, $l_hr, $l_min, $l_sec, $l_frac, $l_year) =
                    $spRightLine =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
                $thisTime = timelocal($l_sec, $l_min, $l_hr, $l_day, $monList{$l_mon}, $l_year) + $l_frac / 1000.0;
            }
        }
        if (! empty($dpleft)) {
            printBlockSep("DP Left");
            $thisTime = 0;
            while (defined(my $dpLeftLine = <DPLEFT>) && ($thisTime < $currentTime)) {
                chomp $dpLeftLine;
                if (! empty($dpLeftLine)) {
                    print "DP Left  - ", $dpLeftLine, "\n";
                    my ($l_weekDay, $l_mon, $l_day, $l_hr, $l_min, $l_sec, $l_frac, $l_year) =
                    $dpLeftLine =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
                    $thisTime = timelocal($l_sec, $l_min, $l_hr, $l_day, $monList{$l_mon}, $l_year) + $l_frac / 1000.0;
                }
            }
        }
        if (! empty($dpright)) {
            printBlockSep("DP Right");
            $thisTime = 0;
            while (defined(my $dpRightLine = <DPRIGHT>) && ($thisTime < $currentTime)) {
                chomp $dpRightLine;
                if (! empty($dpRightLine)) {
                    print "DP Right - ", $dpRightLine, "\n";
                    my ($l_weekDay, $l_mon, $l_day, $l_hr, $l_min, $l_sec, $l_frac, $l_year) =
                    $dpRightLine =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
                    $thisTime = timelocal($l_sec, $l_min, $l_hr, $l_day, $monList{$l_mon}, $l_year) + $l_frac / 1000.0;
                }
            }
        }
        $state = PRINTING_ESS_BLOCK;
        printBlockSep("ESS Log");
        $logLine =~ /${cycleCountRegEx}\s*(Left)\s+/; # Left header line
        $essBlockTime = $3;
        print "$essBlockTime\n";
        $essBlockHMS = parseHMS($essBlockTime);
        printLocalTime($currentTime);
        printLocalTime($currentHMS);
        print "$currentHMS\n";
        printLocalTime($essBlockHMS);
        print "$essBlockHMS\n";
        $currentTime = updateCurrentTime($currentHMS, $essBlockHMS, $currentTime);
        $currentHMS = updateCurrentHMS($currentHMS, $essBlockHMS, $currentHMS);
        printLocalTime($currentTime);
        print $logLine, "\n";
    }
}

close(LOG);
close(SPLEFT);
close(SPRIGHT);
close(DPLEFT) if (! empty($dpleft));
close(DPRIGHT) if (! empty($dpright));

print "Done.\n";

exit(0);
__END__

=head1 NAME

mixLogs.pl - mix the logs from ESS, the MTE log, SP and DP logs

=head1 SYNOPSIS

mixLogs.pl --log=logFile --spleft=spLeftFile --spright=spRightFile [--dpleft=dpLeftFile] [--dpright=dpRightFile]

This is a command to mix the log files from ESS.

  Options:
    --log      The ESS Log File
    --spleft   The left side SP TeraTerm log file
    --spright  The right side SP TeraTerm log file
    --dpleft   The left side DP TeraTerm log file
    --dpright  The right side DP TeraTerm log file

=cut

