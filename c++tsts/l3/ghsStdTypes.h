/*
 *===========================================================================
 *
 *  HEADER FILE:  ghsStdTypes.h
 *
 *===========================================================================
 *
 *  Goodrich Avionics Systems, Inc.
 *  4029 Executive Drive
 *  Beavercreek, OH  45430-1062
 *  (937)426-1700
 *
 *===========================================================================
 *
 *  This file contains proprietary information. This file shall not be
 *  duplicated, used, modified, or disclosed in whole or in part without the
 *  express written consent of Goodrich Avionics Systems, Incorporated.
 *
 *  Copyright (c) 1997-2001, Goodrich Avionics Systems, Incorporated.
 *  All rights reserved.
 *
 *===========================================================================
 *
 *  $Workfile:   ghsStdTypes.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/ghsStdTypes.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:50:02  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 *
 *  Overview:
 *
 *  This is one of the 'standard' files automatically included by the
 *  StdIncl.h 'standard' header file for the SIDE.
 *
 *  This header specifies the 'standard' types associated with the SIDE.
 *
 *  This header is specifically for the Green Hills Integrity OS and compiler
 *
 *===========================================================================
 */


//  Protect against multiple includes
#ifndef __GHSSTDTYPES_H__
#define __GHSSTDTYPES_H__

#ifdef __cplusplus
extern "C" {
#endif


   typedef signed char        byte;           /* 8 bit signed value */
   typedef signed char   	   int8;
   typedef unsigned char      ubyte;          /* 8 bit unsigned value */
   typedef unsigned char  	   uint8;

   typedef signed short       word;           /* 16 bit signed value */
   typedef unsigned short     uword;          /* 16 bit unsigned value */
   typedef short          	   int16;
   typedef unsigned short	   uint16;

   typedef int                dword;          /* 32 bit signed value */
   typedef unsigned int       udword;          /* 32 bit unsigned value */
   typedef int                int32;
   typedef unsigned int 	   uint32;

   typedef long long          qword;          /* 64 bit value */
   typedef unsigned long long uqword;        /* 64 bit unsigned value */
   typedef long long          int64;
   typedef unsigned long 	   uint64;

   typedef float              real;           /* 32 bit floating-point value */
   typedef float              real32;

   typedef double             dreal;          /* 64 bit floating-point value */
   typedef double             real64;

   typedef long double        ereal;          /* 80 bit floating-point value */
   typedef long double        xreal;
   typedef long double        real80;

   typedef unsigned int       boolean;
   #ifdef __cplusplus
     typedef bool			      BOOL;
   #else
     typedef boolean			    bool;           /* bool not supported by GHS C tools. */
     typedef boolean		      BOOL;
   #endif

   #if !defined (true) || !defined (false)
      #define false             0
      #define true              1
   #endif

   #if !defined (TRUE) || !defined (FALSE)
      #define TRUE              true
      #define FALSE             false
   #endif

   #if !defined (True) || !defined (False)
      #define True              true
      #define False             false
   #endif


  /*
   * Common Integrity types:
   *
   * Note: Since C allows redundant typedefs (i.e., it doesn't prevent them),
   * we can go ahead and just set it up here and it won't conflict with the
   * definition in the Integrity "sys/types.h" file.
   *
   *"sys/types.h" is included in StdIncl.h under ghs section
   *
   */
   #define uchar     u_char
   #define int_8	   int8_t
   #define uint_8	   u_int8_t
   #define int_16	   int16_t
   #define uint_16	u_int16_t
   #define int_32	   int32_t
   #define uint_32	u_int32_t
   typedef void *    pointer;     /* Machine representation of a pointer*/



   /*  This is the type for the SmartDeck Method Return Standard
       NOTE:  Variables and attributes based upon this type shall start with 'sr', meaning 'Standard Return' */
   typedef bool             tStdReturn;

   /* typedef bool             bool;
      NOTE: C++ 'standard' type "bool" is used for all boolean's
      NOTE2: bool returns true/false, not TRUE/FALSE

      typedef char             char;
      NOTE: C++ 'standard' type "char" is used for all character/string
            variables (including null-terminated strings) */

   /* create our own MS compatible version of timeb struct & time_t type  */
   typedef long time_t;        /* time value */
   struct _timeb
   {
        time_t time;
        unsigned short millitm;
        short timezone;
        short dstflag;
   };

   /* create our own MS compatible CRITICAL_SECTION  */
   typedef long CRITICAL_SECTION;

   /* create our own MS compatible ALL CAPS types */
   typedef Object* 	      HANDLE;
   typedef char* 	         LPVOID;
   typedef long  	         DWORD;
   typedef short	         WORD;
   typedef long		      LONG;
   typedef unsigned long   ULONG;
   typedef unsigned int    UINT;
   typedef const char*	   LPCSTR;
   typedef const char*	   LPTSTR;
   typedef unsigned long   LPARAM;
   typedef double	         DOUBLE;
   typedef unsigned long   DWORDLONG;
   typedef unsigned char BYTE;

   /* create our own MS compatible LARGE_INTEGER */
   typedef union _LARGE_INTEGER
   {
     struct LowHigh
     {
       DWORD LowPart;
       LONG  HighPart;
     };
     long QuadPart;
   } LARGE_INTEGER, *PLARGE_INTEGER;

   // create our own MS compatible RGBQUAD
   typedef struct tagRGBQUAD
   {
     BYTE rgbBlue;
     BYTE rgbGreen;
     BYTE rgbRed;
     BYTE rgbReserved;
   } RGBQUAD;


#ifdef  __cplusplus
}
#endif


#endif   /* __GHSSTDTYPES_H__ */

/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/ghsStdTypes.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.2   Jul 24 2003 16:24:48   ShellM
 * fixed integrity problem with signed char type def for int8 type
 * 
 *    Rev 1.1   Jan 02 2003 18:04:40   ShellM
 * updated to handle correct c++/c selection of bool types
 * 
 *    Rev 1.0   Dec 12 2002 10:17:34   ShellM
 * Initial revision.
 *
 ************************************************************************/


