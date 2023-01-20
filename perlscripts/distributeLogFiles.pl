#!/usr/bin/env perl
use strict;
use warnings;
use File::Compare;
use File::Copy;
use File::Path;
use Time::Local;

my @monthList = ( "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" );
my $merge = "p:/edt/logfiles/mergedLogRepository/Log Files";
my $pPath = "P:/ESS DATA/";
my $jPath = "J:/ESS/EU Logs/SN ";

opendir my $dh, $merge or die "Could not open $merge : $!";
my @essFiles = reverse sort grep { /[23][0-5]\d\d 20\d\d-[01]\d-[0123]\d [012]\d.\d\d JSF EU ESS.txt$/ } readdir $dh;
closedir $dh;
opendir $dh, $merge or die "Could not open $merge : $!";
my @logFiles = sort grep { /(TeraTerm|UDP)-SP-(Left|Right)-20\d\d-[01]\d-[0123]\d-[012]\d\d\d\d\d.log$/ } readdir $dh;
closedir $dh;

for my $thisESS (@essFiles) {
    my ($sn, $yr, $mon, $day, $hr, $min) = # serial number, year, month, day, hour, minute
        $thisESS =~ /([23][0-5]\d\d) (20\d\d)-([01]\d)-([0123]\d) ([012]\d).(\d\d) JSF EU ESS.txt/;
    my $monName = $monthList[$mon-1];
    print "Processing $thisESS -- EU $sn $yr-$mon-$day $hr:$min\n";
    my @files = ( $thisESS );
    # Only look through the TeraTerm files if we think we have not
    # copied them before. Figuring out which TeraTerm files match
    # the ESS run is expensive.
    if ((! -f ($pPath . "$sn/$thisESS")) ||
        (! -f ($jPath . "$sn/$yr-$mon-$day/$thisESS")) ||
        (File::Compare::compare("$merge/$thisESS", 
            $jPath . "$sn/$yr-$mon-$day/$thisESS"))) {
        # Find TeraTerm logs, reduce search to the same year
        for my $log ( grep { /(TeraTerm|UDP)-SP-(Left|Right)-$yr-[01]\d-[0123]\d-[012]\d\d\d\d\d.log$/ } @logFiles ) {
            my $dateMatch = 0;
            my $unitMatch = 0;
            my $essTimeStamp = timelocal(0, $min, $hr, $day, $mon-1, $yr);
            # TeraTerm log could have started a week or more
            # before, but no more than a couple days after.
            my $loLimit = $essTimeStamp - 2 * 7 * 24 * 60 * 60; # two weeks
            my $hiLimit = $essTimeStamp + 3 * 24 * 60 * 60; # three days
            my ($ttType, $ttLeftRight, $ttYr, $ttMon, $ttDay, $ttHr, $ttMin, $ttSec) = 
                $log =~ /(TeraTerm|UDP)-SP-(Left|Right)-($yr)-([01]\d)-([0123]\d)-([012]\d)(\d\d)(\d\d).log/;
            my $ttTimeStamp = timelocal($ttSec, $ttMin, $ttHr, $ttDay, $ttMon-1, $ttYr);
            if (($ttTimeStamp > $loLimit) && ($ttTimeStamp <= $hiLimit)) {
                open LOG,"$merge/$log" or die "Could not open log $log : $!";
                while (<LOG>) { # log files may be large, iterate line by line
                    $dateMatch = 1 if (/\[\w\w\w $monName $day $hr:$min:\d\d(\.\d\d\d)? $yr\]/);
                    $unitMatch = 1 if (/EU Under Test \((Right|Left)\)\s*: $sn/);
                    last if (($dateMatch) && ($unitMatch));
                }
                close LOG;
            }
            push @files,$log if (($dateMatch) && ($unitMatch));
        }
        print "-- $_\n" for @files;
        mkpath($pPath . "$sn");
        for my $file (@files) {
            copy("$merge/$file", $pPath . "$sn/$file");
        }
        mkpath($jPath . "$sn/$yr-$mon-$day");
        for my $file (@files) {
            copy("$merge/$file", $jPath . "$sn/$yr-$mon-$day/$file");
        }
        print "*****************************\n\n";
    }
}
