//#############################################################################
//
//  L-3 Communications Display Systems
//  JSF PCD Software
//
//#############################################################################
//
/// @file OTP_Counter.h
///       Operational Test Program (OTP)
///
///       Simple Counter class just to test a couple GHS C++ side effects in
///       OTP.
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
#ifndef OTP_COUNTER_H
#define OTP_COUNTER_H
// -------------------------------------------------------------------------- //
// Includes

#include "otp_types.h"

// -------------------------------------------------------------------------- //
// Macros

// -------------------------------------------------------------------------- //
// External Types and Objects

// -------------------------------------------------------------------------- //
// External Function Declarations

class OTP_Counter
{
    public:
        OTP_Counter(UINT32 const initialValue);     // Constructor
        OTP_Counter(const OTP_Counter& copy_from);  // Copy Constructor
        OTP_Counter& operator=(const OTP_Counter& copy_from); // Copy Assignment
        ~OTP_Counter();

        UINT32 getCounter() const;                 // getter
        void setCounter(UINT32 const val);         // setter
        void setName(CHAR const * const name);     // set the name for the count
        CHAR const * const getName() const;
        void increment();
    private:
        enum { nameSize = 50 }; // avoid declaring global data yet makes const
        FLT64 d1;
        UINT32 count;
        FLT64 d2;
        CHAR name[nameSize];
        FLT64 d3;
        INT64 atTime;
        FLT64 d4;
};

// -------------------------------------------------------------------------- //
#endif /* OTP_COUNTER_H */

// #############################################################################
// #
// #  $Id: OTP_Counter.h 8680 2011-08-12 18:49:35Z thompson_e $
// #
// #############################################################################

