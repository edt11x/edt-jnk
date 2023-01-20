#!/usr/bin/env perl

use strict;

my @dns = (
    '208.67.222.222',
    '208.67.220.220',
    '208.53.0.10',
    '216.140.17.254',
    '216.140.16.254',
    '4.2.2.2',
    '4.2.2.3',
    '4.2.2.4',
    '4.2.2.5',
    '4.2.2.6',
    '156.154.70.1',
    '156.154.71.1' );

for (;;)
{
    my @copydns = @dns;
    my $index = 0;
    my $thisOne = "";
    open(FILE, ">/etc/resolv.conf") || die("No resolv.conf");
    for (my $i = 0; $i < $#copydns; $i++)
    {
        do
        {
            $index = int(rand($#copydns));
            $thisOne = $copydns[$index];
            delete $copydns[$index];
        } until (defined($thisOne));
        print FILE "nameserver ", $thisOne, "\n";
    }
    close(FILE);
    sleep 10;
}
