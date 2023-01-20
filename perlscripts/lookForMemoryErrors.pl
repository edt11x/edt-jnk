#!/usr/bin/env perl
#
# Modify this to find groups of 8 but not groups of 7 or 9, etc.,  memory errors.
#
use strict;
use warnings;

foreach my $file ( glob '*.log' ) {
    my @list;
    my $checkNextLine = 0;
    open my $fh, $file or die $!;
    while (<$fh>) {
        chomp;
        my $line = $_;
        if (($checkNextLine) && ($line !~ /Memory Error #[1-9]\s/)) {
            print "\n\n$file\n", join("\n", @list);
            undef @list;
        }
        $checkNextLine = 0;
        undef @list if ($line !~ /Memory Error/);
        if ($line =~ /Memory Error #[1-8]\s/) {
            push(@list, $line); # save memory errors 1-8
            $checkNextLine = 1 if ($line =~ /Memory Error #8\s/);
        }
    }
    close $fh;
}
