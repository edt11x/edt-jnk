#! perl
use strict;
use warnings;

my $thisLine = "";
my $thisMemRead = "";
my $lookForResults = "";
my $thisResult = "";

my %results = ();
my %secondPossibility = ();

my $line = 1;

$| = 1;

open FILE,"results.log" or die "No file : $!";
while (<FILE>)
{
    chomp;
    s/\r//;
    s/\s+$//;
    tr/A-Z/a-z/;
    $thisLine = $_;
    $thisMemRead = "";
    $thisResult = "";
    if ($thisLine =~ /ppc7448.* mr (0x.*)/)
    {
        $thisMemRead = $1;
    }
    elsif (($lookForResults ne "") && ($thisLine =~ /^$lookForResults: (0x.*)/))
    {
        $thisResult = $1;
        if (defined($results{$lookForResults}))
        {
            # it better match
            if ($results{$lookForResults} ne $thisResult)
            {
                if (!defined($secondPossibility{$lookForResults}))
                {
                    print "Second possibility, line $line, @" . $lookForResults . " expected " . $results{$lookForResults} . ", got " . $thisResult . "\n";
                    $secondPossibility{$lookForResults} = $thisResult;
                }
                elsif ($secondPossibility{$lookForResults} ne $thisResult)
                {
                    print "Unexpected result, line $line, @" . $lookForResults . " expected " . $results{$lookForResults} . ", got " . $thisResult . "\n";
                }
            }
        }
        else
        {
            print "Print new result " . $lookForResults . " - " . $thisResult . "\n";
            $results{$lookForResults} = $thisResult;
        }
        $lookForResults = "";
    }
    $lookForResults = $thisMemRead;
    $line++;
}
close(FILE);

exit 0;

# 0xf10003c4: 0x6ebdeb91
# 0xf10003d4: 0x4f1e2c0c
# 0xf100f328: 0xa6000001
# 0xf10014c0: 0x4a01cf07
# 0xf1000000: 0xff000002
# 0xf1000068: 0x00f10001
# 0xf1000120: 0x5b030000
# 0xf10003b4: 0x7302cb07
# 0xf1001d1c: 0xffffeb03
# 0xf1001d9c: 0xffffef03
# 0xf100046c: 0xffffef8f
# 0xf1001404: 0x400500c3
# 0xf1000d00: 0x34000080
# 0xf1000d80: 0x35000080
# 0xf1001da0: 0x61080d00
# 0xf1001d20: 0x610a0d00
# 0xf1002444: 0x1c1c0000
# 0xf1002844: 0x1c1c0000
# 0xf1002c44: 0x1c1c0000
# 0xf1000160: 0x00cb0400
# 0xf10020a0: 0x0b000d00
