#!/usr/bin/env perl
use strict;
use warnings;

use Time::Local;

my @spDataFiles = qw( TeraTerm-SP-Left-2013-11-25-151610.log 
                      TeraTerm-SP-Right-2013-11-25-151611.log);
my @dpDataFiles = qw( TeraTerm-DP-Left-2013-11-25-151613.log
                      TeraTerm-Com-3-2013-11-25-232123.log);
my %mon2num = qw( Jan 0  Feb 1  Mar 2  Apr 3  May 4  Jun 5
                  Jul 6  Aug 7  Sep 8  Oct 9  Nov 10 Dec 11);

sub getTimeStamp {
    $_[0] =~ m/^\[\w\w\w (\w\w\w) (\d*) (\d\d):(\d\d):(\d\d)\.\d\d\d (\d\d\d\d)\]/;
    my ($mon, $day, $hour, $min, $sec, $year) = ($1, $2, $3, $4, $5, $6);
    my $timeStamp = timelocal($sec, $min, $hour, $day, $mon2num{$mon}, $year - 1900);
    return $timeStamp;
}

my $coldBoots = 0;
for my $i (0 .. $#spDataFiles) {
    print "\n\nParsing ", $spDataFiles[$i], "\n";
    open SP, $spDataFiles[$i] or die "No file";
    my $eblPos = 0;
    my $bootTimeStamp = 0;
    while (<SP>) {
        chomp;
        if (/EBL Formal/) {
            print "\n\n*** Found EBL Formal Banner\n", $_, "\n";
            $eblPos = 0;
            $bootTimeStamp = getTimeStamp($_);
        }
        if ((/VP   Module Temperature : -/) && ($eblPos < 50)) {
            print "*** Found Negative VP Boot Temperature\n", $_, "\n";
            open DP, $dpDataFiles[$i] or die "No file";
            $coldBoots++;
            while (<DP>) {
                chomp;
                if ((getTimeStamp($_) > ($bootTimeStamp - 60 * 3)) &&
                    (getTimeStamp($_) < ($bootTimeStamp + 60 * 3))) {
                    print $_, "\n" if (! /pcd_get_ipc/);
                }
            }
            close DP;
        }
        $eblPos++;
    }
    close SP;
}
print "\nFound $coldBoots applicable cold boots\n\n";
exit 0;
