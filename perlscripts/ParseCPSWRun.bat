#@perl -w -S -x %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
#@goto endofperl
#!perl
use strict;
#
# Configuration
#
my $PAYLOAD        = 512;
my $MS_HEADER      = 16;
my $VS_HEADER      = 32;
my $XMIT_BUFFERS   = 40;
my $MAX_TIME_DELTA = 32;    # 32 uSeconds
my $STOF_1_LEN     = 40;
my $STOF_2_LEN     = 92;

#
sub analyzeCPSWRun {
my ($thisFile)    = @_;
my $lineCount     = 0;
my @pieces        = ();
my $deltaTime     = 0;
my $packetSize    = 0;
my $receiveChan   = 0;
my $state         = "unknown";
my $lastDeltaTime = 0;
my $msCount       = 0;
my $vsCount       = 0;
my $i             = "";
my $j             = 0;

    open(FILE, "$thisFile") || die("no file $thisFile");
    while (<FILE>) {
        @pieces      = split(',', $_);
        $deltaTime   = $pieces[0];
        $packetSize  = $pieces[9];
        $receiveChan = $pieces[12];
        $j = 0;
        foreach $i (@pieces) {
            printf("%s\n", $pieces[$i]);
            print "$j --" . $pieces[$i] . "--\n";
            $j++;
        }
        print "$deltaTime $packetSize $receiveChan \n";
        exit(0);
        $lineCount++;
        if ($state eq "unknown") {
            # any packet is accepted
            $lastDeltaTime = $deltaTime;
            if ($packetSize == ($PAYLOAD + $MS_HEADER)) {
                $state   = "mission systems";
                $msCount = 0;
            }
            if ($packetSize == ($PAYLOAD + $VS_HEADER)) {
                $state   = "vehicle systems";
                $vsCount = 0;
            }
        }
        # check for transmitions
        if ($state eq "mission systems") {
            if ($msCount == $XMIT_BUFFERS) {
                # time to switch state
                $state = "vehicle systems";
                $msCount = 0;
            }
        }
        if ($state eq "vehicle systems") {
            if ($vsCount == $XMIT_BUFFERS) {
                # switch to mission systems state
                $state = "mission systems";
                $vsCount = 0;
            }
        }

        if (($packetSize == $STOF_1_LEN) || ($packetSize == $STOF_2_LEN)) {
            # skip the packet
        } elsif ($state eq "mission systems") {
            if ($packetSize == ($PAYLOAD + $MS_HEADER)) {
                $msCount++;
                # Check the count
                if ($msCount > $XMIT_BUFFERS) {
                    print "Mission Systems packet count is $msCount at line $lineCount\n";
                }
                # Check the time
                if ($deltaTime > $MAX_TIME_DELTA) {
                    print "Time Delta too large on Mission Systems packet. Time Delta $deltaTime at line $lineCount\n";
                }
             } else {
                print "Unexpected packet at line $lineCount, $_ \n";
             }
        } elsif ($state eq "vehicle systems") {
            if ($packetSize == ($PAYLOAD + $VS_HEADER)) {
                $vsCount++;
                # Check the count
                if ($vsCount > $XMIT_BUFFERS) {
                    print "Vehicle Systems packet count is $msCount at line $lineCount\n";
                }
                # Check the time
                if ($deltaTime > $MAX_TIME_DELTA) {
                    print "Time Delta too large on Vehicle Systems packet. Time Delta $deltaTime at line $lineCount\n";
                }
             } else {
                print "Unexpected packet at line $lineCount, $_ \n";
             }
         }
    }
}

&analyzeCPSWRun('cpswrun.csv');
#__END__
#:endofperl
