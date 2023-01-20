#! perl -w

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "tryacd.pl loaded "; }
END {print "not ok 1\n" unless $loaded;}
use Win32::SerialPort 0.06;
use IO::Socket;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# package COM1demo2;
use strict;


# my $cfgfile = $file."_test.cfg";
my $tc = 2;		# next test number
my $ob;
my $pass;
my $sock;
my $new_sock;
my $thisMsg;
my $buffer;
my $len;
my $thisLen;
my $count;
my $i;
my $again;
my @messages;

my $e="\r\n....Bye\r\n";
my $loc="\r\n";

$len     = 1024;
$thisLen = 0;
#
# socket init
#
print "Opening socket.... ";
$sock = new IO::Socket::INET(PeerAddr => '150.1.1.2',
                             PeerPort  => 6666,
                             Proto     => 'tcp'
                             );
# $sock = new IO::Socket::INET(PeerAddr => '150.1.1.48',
#                               PeerPort  => 6500,
#                               Proto     => 'tcp',
#                               Listen    => 5,
#                               Reuse     => 1
#                               );
die "Socket could not be created. Reason $!" unless $sock;

print "Socket is open\n";
sleep 1;
close($sock);
