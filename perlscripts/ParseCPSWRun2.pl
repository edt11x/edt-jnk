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
my $MAX_TIME_DELTA = 100;    # 100 uSeconds
my $STOF_1_LEN     = 40;
my $STOF_2_LEN     = 92;

#
sub analyzeCPSWRun {
my ($thisFile)      = @_;
my $lineCount       = 0;
my @pieces          = ();
my $deltaTime       = 0;
my $packetSize      = 0;
my $receiveChan     = 0;
my $msCount         = 0;
my $vsCount         = 0;
my $i               = "";
my $totalMSDelta    = 0;
my $totalVSDelta    = 0;
my $totalErrCount   = 0;

    open(FILE, "$thisFile") || die("no file $thisFile");
    while (<FILE>) {
        @pieces      = split(',', $_);
        $deltaTime   = $pieces[0];
        $packetSize  = $pieces[9];
        $receiveChan = $pieces[12];
        $lineCount++;

        if (($packetSize == $STOF_1_LEN) || ($packetSize == $STOF_2_LEN)) {
            # skip the packet
            $totalMSDelta += $deltaTime;
            $totalVSDelta += $deltaTime;
        }
        if ($packetSize == ($PAYLOAD + $MS_HEADER)) {
            $msCount++;
            $totalMSDelta += $deltaTime;
            $totalVSDelta += $deltaTime;
            # Check the count
            if ($msCount > $XMIT_BUFFERS) {
                print "Mission Systems packet count is $msCount at line $lineCount\n";
                print "---------------------------------------------------------------\n";
                $totalErrCount++;
            }
            if (($msCount != 1) && ($totalMSDelta > $MAX_TIME_DELTA)) {
                print "Time Delta too large on Mission Systems packet. Packet Count $msCount Time Delta $deltaTime at line $lineCount\n";
                print "$_";
                print "---------------------------------------------------------------\n";
                # Probably the start of a new run?
                $msCount = 1;
                $totalErrCount++;
            }
            if ($msCount >= $XMIT_BUFFERS) {
                $msCount = 0;
            }
            $totalMSDelta = 0;
        }
        
        if ($packetSize == ($PAYLOAD + $VS_HEADER)) {
            $vsCount++;
            $totalMSDelta += $deltaTime;
            $totalVSDelta += $deltaTime;
            # Check the count
            if ($vsCount > $XMIT_BUFFERS) {
                print "Vehicle Systems packet count is $msCount at line $lineCount\n";
                print "---------------------------------------------------------------\n";
                $totalErrCount++;
            }
            # Check the time
            if (($vsCount != 1) && ($totalVSDelta > $MAX_TIME_DELTA)) {
                print "Time Delta too large on Vehicle Systems packet. Packet Count $vsCount Time Delta $deltaTime at line $lineCount\n";
                print "$_";
                print "---------------------------------------------------------------\n";
                # Probably the start of a new run?
                $vsCount = 1;
                $totalErrCount++;
            }
            if ($vsCount >= $XMIT_BUFFERS) {
                $vsCount = 0;
            }
            $totalVSDelta = 0;
        }
    }
    print "Total Error Count $totalErrCount\n";
}

&analyzeCPSWRun('cpswrun.csv');
#__END__
#:endofperl
