#!/usr/bin/env perl
use strict;
use warnings;
use File::Find;
# I do not think we will ever have 99 MTEs.
for my $i (1..99) {
    # if we do not specify an EUMTE directory to process
    # or this MTE is in the list of EUMTEs in the arguments
    if ((@ARGV == 0) || (grep { $_ eq ("EUMTE" . $i) } @ARGV)) {
        my $mte = "p:/edt/logfiles/EUMTE" . $i;
        if (-d $mte) {
            print "\n$mte\n";
            my $lastCount = 0;
            my $doItAgain = 1;
            while ($doItAgain--) {
                my @dirs = ();
                opendir my($dh), $mte or die "Could not open $mte : $!";
                for my $d (readdir $dh) {
                    push @dirs,($mte . "/" . $d . "/Log Files") if (-d ($mte . "/" . $d . "/Log Files"));
                }
                closedir $dh;
                @dirs = sort @dirs;
                if ((@dirs > 0) && (@dirs != $lastCount)) {
                    my $opts = "";
                    if (@dirs == 1) {
                        $opts = "--leave"; # leave latest data set in MTE directory
                    } else {
                        $doItAgain = 1;    # there are more data sets to process
                    }
                    print "Working on $dirs[0], count - " . scalar(@dirs) . ", last - $lastCount $opts\n";
                    system("perl r:/tools/edt/compareIntoDirectory.pl --quieter --overwrite-bigger-newer $opts --into=\"p:/edt/logfiles/mergedLogRepository/Log Files\" --from=\"$dirs[0]\"");
                }
                finddepth( sub { rmdir }, $mte);
                $lastCount = @dirs;
            }
        }
    }
}
