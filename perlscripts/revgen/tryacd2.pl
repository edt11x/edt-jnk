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
my $count;
my $i;

my $e="\r\n....Bye\r\n";
my $loc="\r\n";

#
# socket init
#
$sock = new IO::Socket::INET(PeerAddr => '150.1.1.49',
                             PeerPort  => 6500,
                             Proto     => 'tcp',
                             Listen    => 5,
                             Reuse     => 1
                             );
# $sock = new IO::Socket::INET(PeerAddr => '150.1.1.48',
#                              PeerPort  => 6500,
#                              Proto     => 'tcp'
#                              );
die "Socket could not be created. Reason $!" unless $sock;

print "Socket is open\n";

while ($new_sock = $sock->accept()) {
# $thisMsg = sprintf("%c%s%c", 2, "0014320101 0303201", 10);

# print "Sending the message 1 --$thisMsg--\n";

# print $sock $thisMsg;

$thisMsg = sprintf("%c%s%c", 2, "0019320101 000HANDSHAKE", 10);

print "Sending the message 2 --$thisMsg--\n";

print $sock $thisMsg;
print $sock $thisMsg;
print $sock $thisMsg;
print $sock $thisMsg;
print $sock $thisMsg;
print $sock $thisMsg;

# sleep 10;

print "Attempting the read loop\n";

$len = 1024;

$buffer = "";
$count = 0;
for ($i=0; $i<10; $i++) {
    while (($buffer eq "")  && ($count < 100000)) {
        # read $sock, $buffer, $len;
        read $sock, $buffer, $len, 0;
        $count++;
    }
    print "reading....\n";
    print "--$buffer--\n";
}
print "Count is $count\n";
print "Message is --$buffer--\n";

sleep 1;
close($sock);
}
