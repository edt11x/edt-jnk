#!/usr/bin/env perl

my @args = glob "@ARGV";

foreach my $arg (@ARGV)
{
    if ((defined($arg)) && ($arg ne ""))
    {
        print "--" . $arg . "--\n";
    }
}

