#!/usr/bin/env perl

#
# This script takes coefficients for the Color Transformation from RGB to YCbCr
# and computes the values to load into the ATI chipset D1COLOR_MATRIX_COEF registers.
# These registers use a binary fixed point representation of the coefficients
# with the sign bit split off on its own and different parts of the registers
# depending on the fixed point format for that register.
#

sub byteSwap
{
    local($val)    = @_;
    local $thisRes = 0;
    $thisRes = (((($val) & 0xff)       << 24) | ((($val) & 0xff00)     <<  8) | ((($val) & 0xff0000)   >>  8) | ((($val) & 0xff000000) >> 24));
    return $thisRes;
}

sub S0_11
{
    local($thisVal) = @_;
    local $thisRes  = 0;

    # Get the sign
    local $thisSign = ($thisVal >= 0.0) ? 1 : -1;
    $thisVal = abs($thisVal);

    # Get the Integer and fraction portions
    local $thisInt = int($thisVal);
    if ($thisInt > 0)
    {
        print "S0_11 conversion overflow on $thisVal\n";
        exit(1);
    }
    if ($thisInt < 0)
    {
        print "S0_11 conversion underflow on $thisVal\n";
        exit(1);
    }
    local $thisFrac = $thisVal - $thisInt;

    $thisRes = int(($thisFrac * (2**11)) + 0.5);

    if ($thisSign < 1)
    {
        $thisRes = -$thisRes;
    }

    # Mask off only the 12 relavent bits
    $thisRes = $thisRes & 0xFFF;

    local $regVal = (($thisRes & 0x7ff) << 5) | (($thisRes & 0x800) ? (1 << 31) : 0);

    local $regSwap = &byteSwap($regVal);

    return ($thisRes, $regVal, $regSwap);
}


sub S1_11
{
    local($thisVal) = @_;
    local $thisRes  = 0;

    # Get the sign
    local $thisSign = ($thisVal >= 0.0) ? 1 : -1;
    $thisVal = abs($thisVal);

    # Get the Integer and fraction portions
    local $thisInt = int($thisVal);
    if ($thisInt > 1)
    {
        print "S1_11 conversion overflow on $thisVal\n";
        exit(1);
    }
    if ($thisInt < 0)
    {
        print "S1_11 conversion underflow on $thisVal\n";
        exit(1);
    }
    local $thisFrac = $thisVal - $thisInt;

    $thisRes = int(($thisFrac * (2**11)) + 0.5) | $thisInt * (2**12);

    if ($thisSign < 1)
    {
        $thisRes = -$thisRes;
    }

    # Mask off only the 13 relavent bits
    $thisRes = $thisRes & 0x1FFF;

    local $regVal = (($thisRes & 0xfff) << 5) | (($thisRes & 0x1000) ? (1 << 31) : 0);

    local $regSwap = &byteSwap($regVal);

    return ($thisRes, $regVal, $regSwap);
}

sub S11_1
{
    local($thisVal) = @_;
    local $thisRes  = 0;

    # Get the sign
    local $thisSign = ($thisVal >= 0.0) ? 1 : -1;
    $thisVal = abs($thisVal);

    # Get the Integer and fraction portions
    local $thisInt = int($thisVal);
    if ($thisInt > (2**11))
    {
        print "S1_11 conversion overflow on $thisVal\n";
        exit(1);
    }
    if ($thisInt < 0)
    {
        print "S1_11 conversion underflow on $thisVal\n";
        exit(1);
    }
    local $thisFrac = $thisVal - $thisInt;

    $thisRes = int(($thisFrac * 2) + 0.5) | $thisInt * 2;

    if ($thisSign < 1)
    {
        $thisRes = -$thisRes;
    }

    # Mask off only the 13 relavent bits
    $thisRes = $thisRes & 0x1FFF;
    printf("This Result 0x%04X\n", $thisRes);

    local $regVal = (($thisRes & 0xfff) << 15) | (($thisRes & 0x1000) ? (1 << 31) : 0);

    local $regSwap = &byteSwap($regVal);

    return ($thisRes, $regVal, $regSwap);
}

#
# The transformation used here is:
#
# Y  =  0.183 * R + 0.614 * G + 0.062 * B + 64
# Cb = -0.101 * R - 0.338 * G + 0.439 * B + 512
# Cr =  0.439 * R - 0.399 * G - 0.040 * B + 512
#
# This is the YCbCr conversion when 10 bit RGB
# data is used, assuming the RGB data to be full
# range data (0..1023). See the Video Demystified
# book by Keith Jack, the Color Spaces chapter,
# YCbCr Color Space, the Computer System
# Considerations paragraphs. (pg 21 in the Fifth
# Edition).
#
# Also very important is Mark Chan's email to
# use with the subject ATI DVO YCbCr Mode.
#
# The incoming RGB has a positive shift of 512, so 
# we have to subtract that back out
# when computing the C14, C24 and C34 constants.
#

# Calculate Cr
my $C11   = 0.439;
my $C12   = -0.399;
my $C13   = -0.040;
my $C14   = 512 - ($C11 + $C12 + $C13) * 512;
# Calculate Y
my $C21   = 0.183;
my $C22   = 0.614;
my $C23   = 0.062;
my $C24   = 64 - ($C21 + $C22 + $C23) * 512;
# Calculate Cb
my $C31   = -0.101;
my $C32   = -0.338;
my $C33   = 0.439;
my $C34   = 512 - ($C31 + $C32 + $C33) * 512;

my $res   = 0;
my $reg   = 0;
my $swp   = 0;

print "This perl script attempts to compute the coefficient values for the ATI Colour Space Conversion Engine.\n";
print "\n";

($res, $reg, $swp) = &S1_11($C11);
printf("Convert C11 to S1.11 format, $C11 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C11 = $swp;
($res, $reg, $swp) = &S0_11($C12);
printf("Convert C12 to S0.11 format, $C12 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C12 = $swp;
($res, $reg, $swp) = &S0_11($C13);
printf("Convert C13 to S0.11 format, $C13 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C13 = $swp;
($res, $reg, $swp) = &S11_1($C14);
printf("Convert C14 to S11.1 format, $C14 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C14 = $swp;
print "\n";

($res, $reg, $swp) = &S0_11($C21);
printf("Convert C21 to S0.11 format, $C21 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C21 = $swp;
($res, $reg, $swp) = &S1_11($C22);
printf("Convert C22 to S1.11 format, $C22 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C22 = $swp;
($res, $reg, $swp) = &S0_11($C23);
printf("Convert C23 to S0.11 format, $C23 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C23 = $swp;
($res, $reg, $swp) = &S11_1($C24);
printf("Convert C24 to S11.1 format, $C24 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C24 = $swp;
print "\n";

($res, $reg, $swp) = &S0_11($C31);
printf("Convert C31 to S0.11 format, $C31 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C31 = $swp;
($res, $reg, $swp) = &S0_11($C32);
printf("Convert C32 to S1.11 format, $C32 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C32 = $swp;
($res, $reg, $swp) = &S1_11($C33);
printf("Convert C33 to S0.11 format, $C33 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C33 = $swp;
($res, $reg, $swp) = &S11_1($C34);
printf("Convert C34 to S11.1 format, $C34 => 0x%04X, 0x%08X, 0x%08X\n", $res, $reg, $swp);
$C34 = $swp;
print "\n";

printf("write32 0x80006b84 0x%08X # C11 calculated value\n", $C11);
printf("write32 0x80006b88 0x%08X # C12 calculated value\n", $C12);
printf("write32 0x80006b8c 0x%08X # C13 calculated value\n", $C13);
printf("write32 0x80006b90 0x%08X # C14 calculated value\n", $C14);
printf("write32 0x80006b94 0x%08X # C21 calculated value\n", $C21);
printf("write32 0x80006b98 0x%08X # C22 calculated value\n", $C22);
printf("write32 0x80006b9c 0x%08X # C23 calculated value\n", $C23);
printf("write32 0x80006ba0 0x%08X # C24 calculated value\n", $C24);
printf("write32 0x80006ba4 0x%08X # C31 calculated value\n", $C31);
printf("write32 0x80006ba8 0x%08X # C32 calculated value\n", $C32);
printf("write32 0x80006bac 0x%08X # C33 calculated value\n", $C33);
printf("write32 0x80006bb0 0x%08X # C34 calculated value\n", $C34);
