#!/usr/bin/perl
# Standard Stuff, Make Perl more picky about the code we write
# Trying to improve on previous versions of this parsing, just
# a bit
use strict;
use warnings;
# We are going to parse timestamps like:
# [Thu Feb  8 10:55:31 2018] in our TeraTerm logs
# We just need a couple things globally the timestamp parsing
use Time::Local;
use Time::localtime;
my %monList = ( "Jan" => 0, "Feb" => 1, "Mar" => 2, "Apr" => 3,
                "May" => 4, "Jun" => 5, "Jul" => 6, "Aug" => 7,
                "Sep" => 8, "Oct" => 9, "Nov" => 10, "Dec" => 11 );
# Find the file that we are going to parse
die "Need a file to parse!" if (!defined($ARGV[0]));
open FILE, $ARGV[0] or die "Can not open file : $!";
# constants
my $TOO_LARGE_TIME = 99999999999999;
# Floating Point Number Regular Expression
my $floatingNumberRegEx = qr/[-+]?[0-9]*\.?[0-9]*/;
# Temperature Regular Expression
# What does a temperature look like in OTP Output?, make it also except nothing
# -20, -20.9, 30, 34.0
my $temperatureRegEx = $floatingNumberRegEx;
my $sixTemperatures = qr/(${temperatureRegEx}),(${temperatureRegEx}),(${temperatureRegEx}),(${temperatureRegEx}),(${temperatureRegEx}),(${temperatureRegEx})/;
# globals that we need
my ( $thisTime, $lastTime, $thisAtTime, $bootTime, $thisAtTimestamp, $lastAtTimestamp );
my $fileName = $ARGV[0];
my $collectTemperatures = 1;
my $lastAtTime = 0;
my $line = 0;
my $prevBootLine = 1;
my $spModuleTemperature = "";
my $spCPUTemperature = "";
my $vpModuleTemperature = "";
my $lvpsModuleTemperature = "";
my $dpModuleTemperature = "";
my $dpCPUTemperature = "";
my $awakeAtTime = "";
my $awakeLine = "";
my $errorsAllowedAtTime = "";
my $bootCount = 0;
my @lossOfSyncPort0 = ();
my @lossOfSyncPort1 = ();
my @lossOfSyncPort2 = ();
my @lossOfSyncPort3 = ();
my @inactivePort0 = ();
my @inactivePort1 = ();
my @inactivePort2 = ();
my @inactivePort3 = ();

while (<FILE>) {
    # increment the line number we are working on
    $line++;
    chomp; # if there is a newline or carriage return-newline, throw it out
    # try to decompose the timestamp that we expect at the beginning of each
    # TeraTerm log line.
    #
    # Only operate on lines with a well formed time stamp
    if (/^\[(\w\w\w) (\w\w\w)\s+(\d+) (\d\d):(\d\d):(\d\d)\.?\d* (\d\d\d\d)\]/) {
        my ($weekDay, $mon, $day, $hr, $min, $sec, $year) =
            $_ =~ /^\[(\w\w\w) (\w\w\w)\s+(\d+) (\d\d):(\d\d):(\d\d)\.?\d* (\d\d\d\d)\]/;
        # convert this back to a comparable timestamp value
        # print "weekDay - $weekDay, mon - $mon, day - $day, hr - $hr, min - $min, sec - $sec, year - $year\n";
        $thisTime = timelocal($sec, $min, $hr, $day, $monList{$mon}, $year);
        if (!defined($bootTime)) {
            $bootTime = $thisTime;
        }
        if (/OTP IS AWAKE at time (\d+)/) {
            $awakeAtTime = $1 + 0;
            $awakeLine = $line;
            $errorsAllowedAtTime = $1 + 30;
        }
        if (/SP\s+Module\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $spModuleTemperature = $1 + 0;
        }
        if (/SP\s+CPU\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $spCPUTemperature = $1 + 0;
        }
        if (/VP\s+Module\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $vpModuleTemperature = $1 + 0;
        }
        if (/LVPS\s+Module\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $lvpsModuleTemperature = $1 + 0;
        }
        if (/DP\s+Module\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $dpModuleTemperature = $1 + 0;
        }
        if (/DP\s+CPU\s+Temperature\s+:\s+(${temperatureRegEx})$/) {
            $dpCPUTemperature = $1 + 0;
        }
        # we need to capture the temperatures at the time the failures occurred.
        my $temperatureString = "$spModuleTemperature,$spCPUTemperature,$vpModuleTemperature,$lvpsModuleTemperature,$dpModuleTemperature,$dpCPUTemperature";
        # Search for the FC Inactive or Loss Of Sync, need to save the temperatures at the time of failure for the report
        push @lossOfSyncPort0, "$_,$temperatureString" if (/Loss Of Sync Port 0/);
        push @lossOfSyncPort1, "$_,$temperatureString" if (/Loss Of Sync Port 1/);
        push @lossOfSyncPort2, "$_,$temperatureString" if (/Loss Of Sync Port 2/);
        push @lossOfSyncPort3, "$_,$temperatureString" if (/Loss Of Sync Port 3/);
        push @inactivePort0, "$_,$temperatureString" if (/Inactive Port 0/);
        push @inactivePort1, "$_,$temperatureString" if (/Inactive Port 1/);
        push @inactivePort2, "$_,$temperatureString" if (/Inactive Port 2/);
        push @inactivePort3, "$_,$temperatureString" if (/Inactive Port 3/);

        # with the EMI MTE UDP logs, we do not get a boot banner, we have to look for other
        # clues that we have rebooted, such as the "at time ###" jumping backwards or
        # seeing address spaces waiting on their GO semaphore. Unfortunately I do not
        # think there is a foolproof way to detect a new boot vs a delayed boot or a
        # reset in the UDP TeraTerm logs, so we will just try to improve on this as we
        # go. First we will just look at the "at time ###" time jumping backwards.
        # This is not gauranteed since a delayed boot could end up with a new time
        # that exceeds the time that the last boot was able to execute for. Different
        # address spaces may get into the print stream at different points, so we
        # need to allow some variation.
        if ((/\s+at\s+time\s+(\d+)$/) || (/,\stime\s(\d+)\.$/)) { # found an "at time ###" in the log
            $thisAtTime = $1;
            if ($thisAtTime != 0) {
                if ((($thisAtTime + 100) < ($lastAtTime)) || ($lastAtTime == 0)) {
                    $bootCount++;
                    if ($bootCount > 1) {
                        # then we want to summarize the previous boot
                        # we found a new boot, try to figure out how long we were off, try to figure out how long we were on
                        my $timeSinceLastBoot = $thisTime - $bootTime;
                        $lastAtTime = $timeSinceLastBoot if ($lastAtTime == 0);
                        my $btASCII = ctime($bootTime);
                        # did anyone have a problem?
                        if ((!@lossOfSyncPort0) && (!@lossOfSyncPort1) && (!@lossOfSyncPort2) && (!@lossOfSyncPort3) &&
                            (!@inactivePort0)   && (!@inactivePort1)   && (!@inactivePort2)   && (!@inactivePort3)) {
                            print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime\n";
                        } else {
                            if ((@lossOfSyncPort0) && ($lossOfSyncPort0[0] =~ /(OTP FC Loss Of Sync Port \d), count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@lossOfSyncPort1) && ($lossOfSyncPort1[0] =~ /(OTP FC Loss Of Sync Port \d), count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@lossOfSyncPort2) && ($lossOfSyncPort2[0] =~ /(OTP FC Loss Of Sync Port \d), count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@lossOfSyncPort3) && ($lossOfSyncPort3[0] =~ /(OTP FC Loss Of Sync Port \d), count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@inactivePort0) && ($inactivePort0[0] =~ /(OTP FC Inactive Port \d) Interrupt, count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@inactivePort1) && ($inactivePort1[0] =~ /(OTP FC Inactive Port \d) Interrupt, count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@inactivePort2) && ($inactivePort2[0] =~ /(OTP FC Inactive Port \d) Interrupt, count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                            if ((@inactivePort3) && ($inactivePort3[0] =~ /(OTP FC Inactive Port \d) Interrupt, count \d+, time (\d+),${sixTemperatures}/)) {
                                print "$fileName,$prevBootLine,$bootCount,$btASCII,$timeSinceLastBoot,$lastAtTime,$awakeLine,$awakeAtTime,$errorsAllowedAtTime,$1,$2,$3,$4,$5,$6,$7,$8\n";
                            }
                        }
                    } else {
                        # must be the first boot, we want to print the csv headers
                        print "File,Boot Line #,Boot Count,Boot time,Time Since Last Boot,Time We Operated,Awake Line,Awake Time,Errors Allowed Time,Fault,Fault Time,SP Mod Temp,SP CPU Temp,VP Mod Temp,LVPS Mod Temp,DP Mod Temp,DP CPU Temp\n";
                    }
                    $prevBootLine = $line;
                    $bootTime = $thisTime;
                    @lossOfSyncPort0 = ();
                    @lossOfSyncPort1 = ();
                    @lossOfSyncPort2 = ();
                    @lossOfSyncPort3 = ();
                    @inactivePort0 = ();
                    @inactivePort1 = ();
                    @inactivePort2 = ();
                    @inactivePort3 = ();
                    $spModuleTemperature = "";
                    $spCPUTemperature = "";
                    $vpModuleTemperature = "";
                    $lvpsModuleTemperature = "";
                    $dpModuleTemperature = "";
                    $dpCPUTemperature = "";
                    $awakeAtTime = "";
                    $awakeLine = "";
                    $errorsAllowedAtTime = "";
                }
                $lastAtTime = $thisAtTime + 0; # force numeric
            }
        }

        $lastTime = $thisTime;
    }
}
close (FILE);
