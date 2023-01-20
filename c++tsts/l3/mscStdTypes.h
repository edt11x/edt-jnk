/*
 *===========================================================================
 *
 *  HEADER FILE:  mscStdTypes.h
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
 *  $Workfile:   mscStdTypes.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/mscStdTypes.h-arc  $
 *
 *  $Revision:   2.0.1.0  $
 *
 *  $Date:   Nov 07 2003 08:50:58  $
 *
 *  $Author:   NguyeJ  $
 *
 *===========================================================================
 *
 *  Overview:
 *
 *  This is one of the 'standard' files automatically included by the
 *  StdIncl.h 'standard' header file for the SIDE.
 *
 *  This header specifies the 'standard' types associated with the SIDE.
 *  This header is specific to the Microsoft compiler.
 *
 *===========================================================================
 */

#ifndef __MSCSTDTYPES_H__
#define __MSCSTDTYPES_H__


#ifdef __cplusplus
extern "C" {
#endif


  /* Microsoft defines byte as unsigned char. */
  /* typedef char               byte; */            /* 8 bit value */
   typedef unsigned char       byte;           /* 8 bit value */
   typedef unsigned char       ubyte;          /* 8 bit unsigned value */
   typedef unsigned char       uint8;

   typedef __int8              int8;
   typedef __int16             int16;
   typedef __int32             int32;
   typedef __int64             qword;          /* 64 bit value */
   typedef __int64             int64;

   typedef unsigned __int16    uint16;
   typedef unsigned __int32    uint32;
   typedef unsigned __int64    uint64;
   typedef unsigned __int64    uqword;         /* 64 bit unsigned value */

   typedef short               word;           /* 16 bit value */
   typedef unsigned short      uword;          /* 16 bit unsigned value */

   typedef long                dword;          /* 32 bit value */
   typedef unsigned long       udword;         /* 32 bit unsigned value */

   typedef float               real;           /* 32 bit floating-point value */
   typedef float               real32;

   typedef double              dreal;          /* 64 bit floating-point value */
   typedef double              real64;

   typedef long double         ereal;          /* 80 bit floating-point value */
   typedef long double         xreal;
   typedef long double         real80;


  /* In C++, true and false are "bool" keywords so the old MS construct 
   * we used is invalid. Also MS defines TRUE and FALSE as integer 1 and O
   * so it would cause warnings if we 'typedef bool boolean' and then
   * assign TRUE and FALSE to a variable of boolean type. So we have to 
   * make our boolean an unsigned char. The old method is left here just
   * for documentation in case someone runs into problems with previously
   * valid code.
   */

   typedef unsigned char boolean;

  //COL
  /* These are defined in afx.h. If afx.h has not been included
   * we might as well go ahead and pick up all three.
   */

  #if !defined (TRUE) || !defined (FALSE) || !defined (NULL)

    /* this is how MS has them defined in afx.h (shudder) */
    #undef FALSE
    #undef TRUE
    #undef NULL

    #define FALSE   0
    #define TRUE    1
    #define NULL    0

  #endif /* !defined (TRUE) || !defined (FALSE) || !defined (FALSE) */

  /* Just for reference... */
  #ifdef OLD_BOOLEAN_SUPPORT

    /* Microsoft defines boolean as unsigned char */
    enum boolean {
           false = 0, true  = 1,
           False = 0, True  = 1,
           FALSE = 0, TRUE  = 1
    };
    typedef enum boolean  boolean;

  #endif /* OLD_BOOLEAN_SUPPORT */


   //  This is the type for the SmartDeck Method Return Standard
   //  NOTE:  Variables and attributes based upon this type shall start with 'sr', meaning 'Standard Return'
#ifdef  __cplusplus
   typedef bool             tStdReturn;
#endif



#ifdef  __cplusplus
}
#endif


#endif   /* __MSCSTDTYPES_H__  */


/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/mscStdTypes.h-arc  $
 * 
 *    Rev 2.0.1.0   Nov 07 2003 08:50:58   NguyeJ
 * Allow C code to include this header without failing due to use of C++ bool declaration (for tStdReturn).
 * 
 *    Rev 2.0   Sep 03 2003 15:50:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:48   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 12 2002 10:17:36   ShellM
 * Initial revision.
 * 
 ************************************************************************/

