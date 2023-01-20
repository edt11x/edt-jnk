#!/usr/bin/env perl

use strict;
use warnings;

my %pmcs = (
    "PMC1" => "953",
    "PMC2" => "954",
    "PMC3" => "957",
    "PMC4" => "958",
    "PMC5" => "945",
    "PMC6" => "946",
    "UPMC1" => "937",
    "UPMC2" => "938",
    "UPMC3" => "941",
    "UPMC4" => "942",
    "UPMC5" => "929",
    "UPMC6" => "930"
);

foreach my $pmc (sort keys %pmcs) {
    my $spr = $pmcs{$pmc};
    my $doc = << "END_DOC";
//#############################################################################
//
//  Name  CPU_Set_$pmc
//
/// \@Description
/// Set value of the $pmc
///
/// \@Inputs
/// <B>reg</B>
///    The value for the $pmc register
///
/// \@Outputs
/// <B>None</B>
///
/// \@Return_Values
/// None
//
//#############################################################################
.global CPU_Set_$pmc
CPU_Set_$pmc\:\:

  // we do not need to sync for the performance registers
  mtspr $spr,r3
  blr

END_DOC
    my $doc2 = << "END_DOC_2";
//#############################################################################
//
//  Name  CPU_Set_$pmc
//
/// \@Description
/// Set value of the $pmc
///
/// \@Inputs
/// <B>reg</B>
///    The value for the $pmc register
///
/// \@Outputs
/// <B>None</B>
///
/// \@Return_Values
/// None
//
//#############################################################################
void CPU_Set_$pmc(UINT32 reg);

END_DOC_2
    print $doc2;
}

