#!/usr/bin/perl
use strict;
use warnings;
use Time::Local;
my %monList = ( "Jan" => 0, "Feb" => 1, "Mar" => 2, "Apr" => 3, "May" => 4, "Jun" => 5, "Jul" => 6, "Aug" => 7, "Sep" => 8, "Oct" => 9, "Nov" => 10, "Dec" => 11 );
die "Need a file to parse!" if (!defined($ARGV[0]));
open FILE, $ARGV[0] or die "Can not open file : $!";
my ( $findFirstTemp, $findDPOpenGLReady, $lastTime, $scanningDPPOST, $foundDPPOSTErrors, $handledDPPOSTLog, $atiASICMemFailureCount );
my $dpOpenGLReady = 1;
my $dpOpenGLTempsReported = 1;
my @firstTemps = ();
my @dpOpenGLReadyTemps = ();
while (<FILE>) {
    chomp;
    my ($weekDay, $mon, $day, $hr, $min, $sec, $frac, $year) =
        $_ =~ /^\[(\w\w\w) (\w\w\w) (\d\d) (\d\d):(\d\d):(\d\d)\.(\d\d\d) (\d\d\d\d)]/;
    my $thisTime = timelocal($sec, $min, $hr, $day, $monList{$mon}, $year) + $frac / 1000.0;
    if (($lastTime) && ($thisTime > ($lastTime + 120)) && (! $dpOpenGLReady)) {
        print "DID NOT COMPLETE THE MEMORY TEST\n";
    }
    if (/^\[(\w\w\w \w\w\w \d\d \d\d:\d\d:\d\d\.\d\d\d \d\d\d\d)\]\s+\*\s+EBL Formal/) { # found a boot
        my $abrevBootLine = $_;
        $abrevBootLine =~ s/ - JSF PCD CONSOLE.*$//;
        print "\n=======================================================\n";
        print "Boot at - $abrevBootLine\n";
        print "=======================================================\n\n";
        $findFirstTemp = 1;
        $findDPOpenGLReady = 1;
        $dpOpenGLReady = 0;
        $dpOpenGLTempsReported = 0;
        $atiASICMemFailureCount = 0;
        undef $handledDPPOSTLog;
    }
    if (($findFirstTemp) && (/(SP|VP|IO|FC|LVPS)\s+(CPU|Module)\s+Temperature\s+:\s+(.*)/)) {
        push @firstTemps,$_;
        if ($1 eq "LVPS") {
            print "First Temperatures Reported:\n\n";
            print $_,"\n" for @firstTemps;
            print "\n";
            @firstTemps = ();
            undef $findFirstTemp;
        }
    }
    if (($findDPOpenGLReady) && (/DPopenglReadyFlag\s+set\s+at\s+time\s+(\d+)/)) {
        my $dpOpenGLReadyTime = $1;
        if (($dpOpenGLReadyTime + 0) > 0) {
            print "DP OpenGL Ready was set at time $dpOpenGLReadyTime";
            print ", indicating we did not have to wait for the memory test." if ($dpOpenGLReadyTime < 70);
            print "\n\n$_\n";
            undef $findDPOpenGLReady;
            $dpOpenGLReady = 1;
        }
    }
    if (($dpOpenGLReady) && (! $dpOpenGLTempsReported) && (/(SP|VP|IO|FC|LVPS)\s+(CPU|Module)\s+Temperature\s+:\s+(.*)/)) {
        push @dpOpenGLReadyTemps,$_;
        if ($1 eq "LVPS") {
            print "\nDP OpenGL Ready Temperatures Reported:\n\n";
            print $_,"\n" for @dpOpenGLReadyTemps;
            print "\n";
            @dpOpenGLReadyTemps = ();
            $dpOpenGLTempsReported = 1;
        }
    }
    if ($scanningDPPOST) {
        if (/={5,}/) {
            # just a separator line, keep scanning
        } elsif (/OTP: DP POST:/) {
            # print "--DEBUG2-",$_,"\n";
            $foundDPPOSTErrors = 1;
            if (/ATI ASIC Memory FAIL.*failure count (\d+)/) {
                $atiASICMemFailureCount = $1;
                print "--",$_,"\n";
                print "May have failed the ATI Memory test up to $atiASICMemFailureCount times.\n";
            } elsif (/Video Comp \(MPEG\) Memory FAIL.*failure count (\d+)/) {
                if (($1 + 0) != ($atiASICMemFailureCount + 0)) {
                    print "--",$_,"\n";
                }
            } elsif (/Video Input Memory FAIL.*failure count (\d+)/) {
                if (($1 + 0) != ($atiASICMemFailureCount + 0)) {
                    print "--",$_,"\n";
                }
            } else {
                print "--",$_,"\n";
            }
        } else {
            if (! defined($foundDPPOSTErrors)) {
                print "DP POST log was clean\n";
            }
            undef $scanningDPPOST;
            undef $foundDPPOSTErrors;
            $handledDPPOSTLog = 1;
        }
    }
    if ((! defined($handledDPPOSTLog)) && (/Scanning DP POST/)) {
        # print "--DEBUG--",$_,"\n";
        $scanningDPPOST = 1;
    }
    $lastTime = $thisTime;
}
close (FILE);
