#!/usr/bin/env perl
use strict;
use warnings;
use File::Find ();
use File::Copy;
#
# Get a list of EU ESS Logs into a directory. This script can run a long time.
#
# You need to edit the next two variables before running this script.
#
# Specify the directory where to copy the logs to
my $resultDir = "P:/edt/files/work/l3Displays/UnitInvestigations/tmpLogs/";

# Specify the list of EU ESS Logs to find, we
my @euList = qw(
3102
3113
3116
3114
3093
3124
3125
3081
3079
3058
3045
3058
3024
3036
3016
);

# Normally this will be the repository
my $startDir = "P:/edt/logfiles";

# need a global so we can use it in the File::Find wanted() routine.
my $thisEU;

sub grepit { # ESS logs will have TEMPERATURE written in the header
    open my $fh, $_[0] or die "Could not open $_[0]: $!";
    if ((scalar grep /TEMPERATURE/, <$fh>) > 0) {
        print $_[0] . ", " . (-s $_[0]) . "\n";
        copy($_[0], $resultDir) or die("copy($_[0], $resultDir) failed : $!\n");
    }
}

sub want {
    (-f $_) && (-r $_) && /^$thisEU.*\z/s && grepit($_);
}

chdir "$startDir" or die "Could not change dir to $startDir : $!\n";
foreach my $i (@euList) {
    $thisEU = $i;
    print $thisEU, "\n";
    File::Find::find({wanted => \&want}, '.');
    print "\n";
}
exit;
