#! perl -w

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "demo2.plx loaded "; }
END {print "not ok 1\n" unless $loaded;}
use Win32::SerialPort 0.06;
use IO::Socket;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# starts configuration created by test1.pl

package COM1demo2;
use strict;

my $file = "COM1";
my $cfgfile = $file."_test.cfg";
my $tc = 2;		# next test number
my $ob;
my $pass;
my $fail;
my $in;
my $in2;
my $sock;
my @necessary_param = Win32::SerialPort->set_test_mode_active;

$ob = Win32::SerialPort->start ($cfgfile) or die("Cant start $cfgfile\n");

# 3: Prints Prompts to Port and Main Screen

my $out= "\r\n\r\n++++++++++++++++++++++++++++++++++++++++++\r\n";
my $tick= "Very Simple Half-Duplex Chat Demo\r\n\r\n";
my $tock= "type CAPITAL-Q on either terminal to quit\r\n";
my $e="\r\n....Bye\r\n";
my $loc="\r\n";

print $out, $tick, $tock;
$pass=$ob->write($out);
$pass=$ob->write($tick);
$pass=$ob->write($tock);

$out= "Your turn first";
$tick= "\r\nterminal>";
$tock= "\r\n\r\nperl>";

$pass=$ob->write($out);
## $_ = <STDIN>;		# flush it out (shell dependent)

$ob->error_msg(1);		# use built-in error messages
$ob->user_msg(1);

$fail=0;
open(SAVEFILE, ">savefile") || die("Cant open the save file\n");
#
# socket init
#
$sock = new IO::Socket::INET(PeerAddr => 'thompe',
                            PeerPort  => 1200,
                            Proto     => 'tcp',
                            );
die "Socket could not be created. Reason $!" unless $sock;


close(SAVEFILE);
while (not $fail) {
    # $pass=$ob->write($tick);
    $in = 1;
    while ($in) {
        if (($_ = $ob->input) ne "") {
        	# $ob->write($_);
                s/\r/\n/;
        	print $_;
                print $sock $_;
                open(SAVEFILE, ">>savefile") || die("Cant open the save file\n");
                print SAVEFILE $_;
                close(SAVEFILE);
        	# if (/\cM/) { $ob->write($loc); $in--; }
        	# if (/Q/) { $ob->write($loc); $in--; $fail++; }
        	if ($ob->reset_error) { $ob->write($loc); $in--; $fail++; }
        }
    }
}
print $e;
$pass=$ob->write($e);

sleep 1;
close($sock);

undef $ob;
