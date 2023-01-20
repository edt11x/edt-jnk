#! perl
use IO::Socket::INET;

use strict;
use warnings;

$| = 1; # flush after every write
chdir "C:\\JSF PCD EU MTE Software\\Log Files";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $socket = new IO::Socket::INET( LocalPort => 7101, Proto => 'udp') or 
    die "Error in Socket creation : $!\n";
my $datagram;
my $flags;
my $logFile = sprintf("JSON-SP-Right-%04d-%02d-%02d-%02d%02d%02d.log",
            $year+1900, $mon+1, $mday, $hour, $min, $sec);
open( my $log_fh, ">$logFile") || die "Can not open $logFile : $!";
# print $log_fh "[" . localtime() . "] ";
while (1) {
    if (defined($socket->recv($datagram, 65536, $flags))) {
        if (defined($datagram)) {
            # print $datagram;
            # my $thisTime = "[" . localtime() . "] ";
            # $datagram =~ s/\r?\n/\n$thisTime/g;
            print $log_fh $datagram;
        }
    }
}
close($log_fh);
exit 0;
