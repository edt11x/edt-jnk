use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use Scalar::MoreUtils qw(define);

my @driveLetterList = `net use`;
my %driveLetterMap = ();
for (@driveLetterList) {
    chomp;
    if (/^\w+\s+([A-Z]:)\s+(\S+)/) {
        my $driveLetter = $1;
        my $unc = $2;
        if (defined($driveLetter) && (defined($unc))) {
            $unc =~ s/\\/\//g;
            $driveLetterMap{$driveLetter} = $unc;
        }
    }
}
for my $drive (keys(%driveLetterMap)) {
    print "For $drive the unc is $driveLetterMap{$drive}\n";
}

