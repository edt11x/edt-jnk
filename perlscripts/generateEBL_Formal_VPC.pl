#!perl -w

use strict;
use warnings;

my $verFile = "R:/applications/OTP/src/otp_verification_array.c";
my $eblFile = "R:/applications/EBL_Formal/EBL_Formal.vpc.bin";
my $buffer  = '';

print "Hi There\n";

# get the most recent VPC. EBL_Formal should have built before OTP.
open EBL, "<$eblFile" or die "Can not open EBL_Formal.vpc.bin to get the VPC";
binmode(EBL);
sysread(EBL, $buffer, 4) or die "Can not read EBL_Formal.vpc.bin to get the VPC";
my $vpc = unpack 'N', $buffer;
close(EBL);

printf("The VPC is 0x%08X\n", $vpc);

# we do not care if the unlink fails or not. There may not be a backup file.
unlink "$verFile~";
rename "$verFile", "$verFile~" or die "Cannot rename: $!";

open IN, "<$verFile~" or die "Can not open the original verification file: $!";
open OUT, ">$verFile" or die "Can not open the output verification file: $!";

my $foundIt     = 0;
my $emitResults = 0;
while (<IN>)
{
    if ($foundIt == 0)
    {
        print OUT $_;
        if (/### EBL_Formal Auto Update Area Begin/)
        {
            $foundIt = 1;
        }
    }
    elsif ($emitResults == 0)
    {
        if (/### EBL_Formal Auto Update Area End/)
        {
            $emitResults = 1;
            printf OUT "    { ebl_verify,       \"Extended Boot Loader (EBL)\",    \"Development\",       \"2RZF00010-0014\", \"Development EBL\",       0x%08X, NO_CHECK, NO_CHECK, NO_CHECK, NO_CHECK, NO_CHECK, NO_CHECK, NO_CHECK,\n        verify_entry_valid },\n",
                $vpc;
            print OUT $_;
        }
    }
    else
    {
        print OUT $_;
    }
}

close(IN);
close(OUT);

exit 0;

