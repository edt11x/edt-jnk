#! perl
#
use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/jnk/perlmodules';
use lib '/home/edt/jnk/perlmodules';
use Getopt::Long;

use strict;
use warnings;

my $help = 0;
my $cxx = 0;
my $man = 0;

sub makeTheFile {
    my ($thisFile) = @_;
    my $thisHeaderFileName = $thisFile . ".h";
    my $thisCFileName = $thisFile . ($cxx ? ".cpp" : ".c");
    my $thisUpperName = uc $thisFile;
    my $thisHeaderGuard = $thisUpperName . "_H";

    open(HEADER, ">$thisHeaderFileName") || die("Can not create the header");
    my $headerDoc = <<"ENDHEADER";
//#############################################################################
//
//  L-3 Communications Display Systems
//  JSF PCD Software
//
//#############################################################################
//
/// \@file $thisHeaderFileName
///       Operational Test Program (OTP)
///\\n
/// \@note
///       notes
//
//#############################################################################
//
//  Copyright (c), L-3DS - All rights reserved.
//  This file contains proprietary information and shall not be duplicated,
//  used, modified, or disclosed, in whole or in part outside the JSF program
//  without the expressed written consent of L-3DS.
//
//#############################################################################
#ifndef $thisHeaderGuard
#define $thisHeaderGuard
// -------------------------------------------------------------------------- //
// Includes

#ifndef OTP_TYPES_H
#include "otp_types.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

// -------------------------------------------------------------------------- //
// Macros

// -------------------------------------------------------------------------- //
// External Types and Objects

// -------------------------------------------------------------------------- //
// External Function Declarations

#ifdef __cplusplus
}
#endif

// -------------------------------------------------------------------------- //
#endif /* $thisHeaderGuard */

// #############################################################################
// #
// #  \$Id: $thisHeaderFileName 8680 2011-08-12 18:49:35Z thompson_e \$
// #
// #############################################################################

ENDHEADER
    print HEADER $headerDoc;
    close(HEADER);

    open(CFILE, ">$thisCFileName") || die("Can not create the header");
    my $cFileDoc = <<"ENDCFILE";
//#############################################################################
//
//  L-3 Communications Display Systems
//  JSF PCD Software
//
//#############################################################################
//
/// \@file $thisCFileName
///       Operational Test Program (OTP)
///\\n
/// \@note
///       notes
//
//#############################################################################
//
//  Copyright (c), L-3DS - All rights reserved.
//  This file contains proprietary information and shall not be duplicated,
//  used, modified, or disclosed, in whole or in part outside the JSF program
//  without the expressed written consent of L-3DS.
//
//#############################################################################
// -------------------------------------------------------------------------- //
// Includes
#ifndef OTP_TYPES_H
#include "otp_types.h"
#endif

#include "$thisHeaderFileName"


// -------------------------------------------------------------------------- //
// Macros

// -------------------------------------------------------------------------- //
// External Objects

// ------------------------------------------------------------------------- //
// Global Types and Objects

// ------------------------------------------------------------------------- //
// Internal Function Declarations

// -------------------------------------------------------------------------- //
// Functions
// -------------------------------------------------------------------------- //

//#############################################################################
//
//  Name  otp_some_function_name
//
/// \@Description
/// This function does some function.
///
/// \@Inputs
/// <B>item</B>
///    The item is sent to this function.
///\\n
/// <B>item_len</B>
///     The length of some item.
///
/// \@Outputs
/// <B>item_data</B>
///    Some data about an item.
///
/// \@Return_Values
/// success if all went well
//
//#############################################################################
Return_type otp_some_function_name(Item_type item, void * item_data, UINT32 item_len)
{
    return success;
}

// -------------------------------------------------------------------------- //
// #############################################################################
// #
// #  \$Id: $thisCFileName 8676 2011-08-05 01:52:54Z thompson_e \$
// #
// #############################################################################

ENDCFILE

    print CFILE $cFileDoc;
    close(CFILE);
    # try to add them to subversion
    system("svn add $thisHeaderFileName $thisCFileName");
    # try to set keyword expansion
    system("svn propset svn:keywords 'Id' $thisHeaderFileName $thisCFileName");
}


GetOptions("help|?"      => \$help,
           "cxx"         => \$cxx,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;


if (@ARGV) {
    foreach (@ARGV) { makeTheFile($_); }
}

exit 0;

__END__

=head1 NAME

otpfile.pl - generate files for OTP with headers and added to subversion

=head1 SYNOPSIS

otpfile.pl 

    Options:
      --cxx         generate a C++ file rather than a C file
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<cxx>

Generate a C++ file rather than a C file.

=item B<help>

Print a brief help message and exit.

=item B<man>

Print the manual page and exit.

=back

=head1 DESCRIPTION

This program generates initial source files for OTP.

=cut


