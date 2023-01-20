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
$sock = new IO::Socket::INET(PeerAddr => '150.1.1.48',
                             PeerPort  => 6500,
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
# $thisLen = read $sock, $buffer, $len, 0;

# $thisMsg = sprintf("%c%s%c", 2, "0014320201 0303202", 10);

# print "Sending the message 1 --$thisMsg--\n";

# print $sock $thisMsg;
$sock->autoflush(1);

$again = 1;
while ($again) {

    # print $sock $thisMsg;
    $thisMsg = sprintf("%c%s%c", 2, "0023320301 000HANDSHAKE    ", 10);
    print "Sending the message --$thisMsg--\n";
    syswrite($sock, $thisMsg, 29);
    if (0) {
        for ($i = 0; $i < 2; $i++) {
            $thisMsg = sprintf("%c%s%c", 2, "0023320301 000HANDSHAKE    ", 10);
            print "Sending the message --$thisMsg--\n";
            print "Sending the message --$thisMsg--\n";
            syswrite($sock, $thisMsg, 29);
            syswrite($sock, $thisMsg, 29);
            $thisMsg = sprintf("%c%s%c", 2, "0023320301 000KEEPALIVE    ", 10);
            print "Sending the message --$thisMsg--\n";
            syswrite($sock, $thisMsg, 29);
        }
    }
    # print $sock $thisMsg;
    if ($sock->error)
    {
        print "Whats wrong?\n";
        # perror("Whats wrong?");
    }
    # print $sock $thisMsg;
    # print $sock $thisMsg;
    # print $sock $thisMsg;
    # print $sock $thisMsg;
    # 
    # sleep 10;

    print "Attempting the read loop\n";


    $buffer = "";
    for ($i=0; $i<10; $i++) {
        $count = 0;
        while (($buffer eq "")  && ($count < 1000)) {
            $len = 1024;
            # read $sock, $buffer, $len;
            $thisLen = sysread($sock, $buffer, $len);
            # $thisLen = read $sock, $buffer, $len, 0;
            if ($thisLen) {
                print "len - $thisLen, buffer --$buffer--\n";
                @messages = split("\n", $buffer);
                $buffer = "";
                $thisLen = 0;
                foreach (@messages) {
                    print "Message : $_ \n";
                    if (/HOST/) {
                        print "###################\n";
                    }
                }
            }
            $count++;
        }
        print "reading....\n";
        if ($sock->error)
        {
            print "Whats wrong?\n";
            # perror("Whats wrong?");
        }
    }
    print "\nTry it again ? ";
    $again = <>;
    chomp($again);
}
sleep 1;
close($sock);
