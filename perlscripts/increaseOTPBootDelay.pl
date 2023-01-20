#!/usr/bin/env perl

use strict;
use warnings;


for (my $i = 0; $i < 180; $i++)
{
    open OUT, ">/tftpboot/foo.cmd" or die "Could not open file: $!\n";
    print OUT <<"ENDOFCMD";
request_timeout 5
boot_timeout 20
blocksize 1400
boot_delay $i
boot_address 0x17ff0100
digest 0
dp_net_load 0
file PreBoot.bin
location 0x17ff0000
file OTP.bin
location 0x10000000
ENDOFCMD

    close(OUT);
    print "Current boot delay $i seconds\n";
    sleep(11*60);
}
