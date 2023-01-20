#!/usr/bin/env perl
#
use strict;
use warnings;

use IO::Socket;
my $sock = IO::Socket::INET->new(
    Proto => 'udp',
    PeerPort => 7001,
    PeerAddr => '158.186.41.110') or die "No Socket : $!\n";

$sock->send("Hello Dispatcher") or die "No Send : $!\n";

exit 0;
