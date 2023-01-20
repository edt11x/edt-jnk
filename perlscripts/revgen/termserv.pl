#! perl -w

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "savefile.pl loaded "; }
END {print "not ok 1\n" unless $loaded;}
use Win32::SerialPort 0.06;
use IO::Socket;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

package COM1demo2;
use strict;

sub shuffleFiles {
my($nextFile);
my($thisFile);
my($thatFile);
my($i);

   unlink("sess100.txt");

    for ($i = 100; $i > 1; $i--) {
        $nextFile = "sess" . ($i - 2) . ".txt";
        $thisFile = "sess" . ($i - 1) . ".txt";
        $thatFile = "sess" . $i . ".txt";
        # 
        # If there's no next file (the one for the next loop)
        # there's no need to rename the file if the next one 
        # doesn't exist
        #
        if (($i <= 2) || (-e $nextFile))
        {
            if (-e $thisFile) {
                rename($thisFile, $thatFile);
            }
        }
    }
    rename("session.txt", "sess1.txt");
}

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

my $e="\r\n....Bye\r\n";
my $loc="\r\n";


$ob->error_msg(1);		# use built-in error messages
$ob->user_msg(1);

$fail=0;
&shuffleFiles();
open(SAVEFILE, ">session.txt") || die("Cant open the save file\n");
#
# socket init
#
$sock = new IO::Socket::INET(PeerAddr => '192.168.3.232',
                            PeerPort  => 1200,
                            Proto     => 'tcp',
                            );
die "Socket could not be created. Reason $!" unless $sock;


close(SAVEFILE);
while (not $fail) {
    $in = 1;
    while ($in) {
        if (($_ = $ob->input) ne "") {
        	# $ob->write($_);
        	print $_;
                print $sock $_;
                &shuffleFiles();
                open(SAVEFILE, ">>session.txt") || die("Cant open the save file\n");
                s/\r//g;
                print SAVEFILE $_;
                close(SAVEFILE);
        	if ($ob->reset_error) { $ob->write($loc); $in--; $fail++; }
        }
    }
}
print $e;
$pass=$ob->write($e);

sleep 1;
close($sock);

undef $ob;
