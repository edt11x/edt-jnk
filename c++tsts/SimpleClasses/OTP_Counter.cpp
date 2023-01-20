//#############################################################################
//
//  L-3 Communications Display Systems
//  JSF PCD Software
//
//#############################################################################
//
/// @file OTP_Counter.cpp
///       Operational Test Program (OTP)
///       Simple class just to test a few C++ side effects in OTP, making
///       sure that variables do align even when using the copy constructor
///       or object assignment.
///\n
/// @note
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
#include "OTP_Counter.h"

#include "otp_cast.h"
#include "otp_string.h"

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
OTP_Counter::OTP_Counter(UINT32 const initialCount)
    : d1(0.0),
      count(initialCount),
      d2(0.0),
      d3(0.0),
      atTime(otpGetTime64()),
      d4(0.0)
{
    d1 = otp_cast_UINT32_as_FLT64(count);
    d2 = otp_cast_UINT32_as_FLT64(count) * 2.0;
    d3 = otp_cast_UINT32_as_FLT64(count) * 3.0;
    d4 = otp_cast_UINT32_as_FLT64(count) * 4.0;
    otp_strncpy(name, "No, Name", otp_cast_INT32_as_UINT32(nameSize));
}

// Copy constructor
OTP_Counter::OTP_Counter(OTP_Counter const & copy_from)
    : d1(0.0),
      count(copy_from.count),
      d2(0.0),
      d3(0.0),
      atTime(otpGetTime64()),
      d4(0.0)
{
    d1 = otp_cast_UINT32_as_FLT64(count);
    d2 = otp_cast_UINT32_as_FLT64(count) * 2.0;
    d3 = otp_cast_UINT32_as_FLT64(count) * 3.0;
    d4 = otp_cast_UINT32_as_FLT64(count) * 4.0;
    otp_memcpy(name, copy_from.name, otp_cast_INT32_as_UINT32(nameSize));
}

// Copy assignment
OTP_Counter& OTP_Counter::operator=(OTP_Counter const & copy_from)
{
    if (this != &copy_from)
    {
        count = copy_from.count;
        d1 = copy_from.d1;
        d2 = copy_from.d2;
        d3 = copy_from.d3;
        d4 = copy_from.d4;
        atTime = copy_from.atTime;
        otp_memcpy(name, copy_from.name, otp_cast_INT32_as_UINT32(nameSize));
    }
    return *this;
}

OTP_Counter::~OTP_Counter()
{
}

void OTP_Counter::setCounter(UINT32 const val)
{
    count = val;
}

UINT32 OTP_Counter::getCounter(void) const
{
    return count;
}

void OTP_Counter::setName(CHAR const * const newName)
{
    otp_strncpy(name, newName, otp_cast_INT32_as_UINT32(nameSize));
}

CHAR const * const OTP_Counter::getName(void) const
{
    return name;
}

void OTP_Counter::increment(void)
{
    count++;
    d1 = otp_cast_UINT32_as_FLT64(count);
    d2 = d1 * 2.0;
    d3 = d1 * 3.0;
    d4 = d1 * 4.0;
}

// -------------------------------------------------------------------------- //
// #############################################################################
// #
// #  $Id: OTP_Counter.cpp 8676 2011-08-05 01:52:54Z thompson_e $
// #
// #############################################################################

