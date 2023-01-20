#! perl
use strict;
use warnings;

my %expectedValue =
(
0xf10003c4 => { expected => 0x6ebdeb91, bits => [ 0 .. 31 ] },
0xf10003d4 => { expected => 0x4f1e2c0c, bits => [ 0 .. 31 ] },
0xf100f328 => { expected => 0xa6000001, bits => [ 0, 1, 25 ] },
0xf10014c0 => { expected => 0x4a01cf07, bits => [ 16 ] },
0xf1000000 => { expected => 0xff000002, bits => [ 10, 12 ] },
0xf1000068 => { expected => 0x00f10001, bits => [ 0 .. 19 ] },
0xf1000120 => { expected => 0x5b030000, bits => [ 3, 4, 5, 6, 7 ] },
0xf10003b4 => { expected => 0x7302cb07, bits => [ 16 ] },
0xf1001d1c => { expected => 0xffffeb03, bits => [ 16 ] },
0xf1001d9c => { expected => 0xffffef03, bits => [ 16 ] },
0xf100046c => { expected => 0xffffef8f, bits => [ 0 .. 31 ] },
0xf1001404 => { expected => 0x400500c3, bits => [ 0, 6 ] },
0xf1000d00 => { expected => 0x34000080, bits => [ 2, 4, 5 ] },
0xf1000d80 => { expected => 0x35000080, bits => [ 2, 4, 5 ] },
0xf1001da0 => { expected => 0x61080d00, bits => [ 17, 18 , 19 ] },
0xf1001d20 => { expected => 0x610a0d00, bits => [ 17, 18 , 19 ] },
0xf1002444 => { expected => 0x1c1c0000, bits => [ 0 ] },
0xf1002844 => { expected => 0x1c1c0000, bits => [ 0 ] },
0xf1002c44 => { expected => 0x1c1c0000, bits => [ 0 ] },
0xf1000160 => { expected => 0x00cb0400, bits => [ 8 ] },
0xf10020a0 => { expected => 0x0b000d00, bits => [ 16 ] },
);

sub chomp_plus
{
    my $string = $_[0];
    chomp $string;
    $string =~ s/^\s*//;
    $string =~ s/\s*$//;
    return $string;
}

sub byte_swap
{
    my $string = sprintf("%08X", $_[0]);
    $string =~ /(..)(..)(..)(..)/;
    $string = $4 . $3 . $2 . $1;
    return hex($string);
}

sub bits_diff
{
    my $this = byte_swap($_[0]);
    my $that = byte_swap($_[1]);
    my $ref_bitList = $_[2];

    printf "--- Swap 0x%08X\n", $this;
    printf "--- Swap 0x%08X\n", $that;

    for (my $i = 0; $i < 32; $i++)
    {
        if (($this & (2 ** $i)) != ($that & (2 ** $i)))
        {
            print "--- Bit ", $i, " differs\n";
            foreach my $bit (@$ref_bitList)
            {
                if ($bit == $i)
                {
                    print "******* PROBLEM BIT $i *******\n"
                }
            }
        }
    }
}

open FILE, "All_After_EBL.txt" or die "No file : $!";
while (<FILE>)
{
    print $_;
    chomp;
    if ($_ ne "")
    {
        my @pieces = split(':', $_);
        my $address = hex(chomp_plus($pieces[0]));
        my $value = hex(chomp_plus($pieces[1]));

        if (!defined($expectedValue{$address}{expected}))
        {
            printf "Ack! no address 0x%08X\n", $address;
        }
        elsif ($expectedValue{$address}{expected} != $value)
        {
            printf "0x%08X --> expected 0x%08X, got 0x%08X\n",
                $address, $expectedValue{$address}{expected}, $value;
            my $bitList = $expectedValue{$address}{bits};
            bits_diff($expectedValue{$address}{expected}, $value, $bitList);
        }
    }
}
close(FILE);
exit 0;
