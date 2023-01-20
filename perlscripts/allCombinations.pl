#!/usr/bin/env perl -w

use strict;

sub walk_combinations {

    my $thisRef = shift @_;
    my @mainCopy = @$thisRef;

    for (my $i = 0; $i < scalar(@mainCopy); $i++)
    {
        my @subCopy = @mainCopy;

        if (defined($subCopy[$i]))
        {
            print $subCopy[$i], " ";
            delete $subCopy[$i];
            walk_combinations(\@subCopy);
            print "\n";
        }
    }
}

walk_combinations([ "A", "B", "C", "D" ]);


