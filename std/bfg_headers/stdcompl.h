/*************************************************************************
*
*   BFGoodrich FlightSystems, Incorporated
*   2001 Polaris Parkway
*   Columbus, Ohio 43240-2001
*
*   This file contains proprietary information.  This file shall not be
*   duplicated, used, modified, or disclosed in whole or in part without
*   the express written consent of BFGoodrich FlightSystems, Incorporated.
*
*   Copyright (c) 1994, BFGoodrich FlightSystems, Incorporated.
*   All rights reserved.
*
*   $Workfile:   stdcompl.h  $
*
*    $Archive:   L:/common/sw/std/vcs/stdcompl.h_v  $
*   $Revision:   1.3  $
*       $Date:   07 Nov 1996 11:34:58  $
*     $Author:   HUSTOR  $
*
*   Originally created by Robert S. Huston
*   June 9, 1994
*
*   Tab Setting:  4
*
*   Standard compiler definitions.
*
*   The following compilers are currently supported:
*       __TURBOC__      Borland's Turbo C (and C++) for the PC
*       THINK_C         Symantec's THINK C for the Macintosh
*       _MCC960         Microtec's MCC960 for the PC
*       __i960          Intel's iC-960 for the PC
*       _TMS340         TI's GSPCC for the PC
*       _MSC_VER        Microsoft Visual C++
*
*************************************************************************/

#if !defined(_stdcompl_)
#define _stdcompl_



#ifdef __cplusplus
extern "C" {
#endif



/*
 *
 * Check to see that one of the supported compilers has invoked us.
 *
 */

#if !defined(__TURBOC__) && \
    !defined(THINK_C) &&    \
    !defined(_MCC960) &&    \
    !defined(__i960) &&     \
    !defined(_TMS340) &&    \
    !defined(_MSC_VER)
  #error Supported compiler not found!
#endif



/* Bit, byte, word ordering: */

#if defined(__TURBOC__)

  #define		LITTLE_ENDIAN		/* Right-to-left addressing */
  #define		INTS_R_16_BITS
  #define		INT_SIZE			16

#elif defined(THINK_C)

  #define		BIG_ENDIAN			/* Left_to_right addressing */
  #define		INTS_R_16_BITS
  #define		INT_SIZE			16

#elif defined(__i960)

  #define		LITTLE_ENDIAN		/* Right-to-left addressing */
  #define		INTS_R_32_BITS
  #define		INT_SIZE			32

#elif defined(_MCC960)

  #define		LITTLE_ENDIAN		/* Right-to-left addressing */
  #define		INTS_R_32_BITS
  #define		INT_SIZE			32

#elif defined(_MSC_VER)

  #define		LITTLE_ENDIAN		/* Right-to-left addressing */
  #define		INTS_R_32_BITS
  #define		INT_SIZE			32

#elif defined(_TMS340)

  #define		LITTLE_ENDIAN		/* Right-to-left addressing */
  #define		INTS_R_32_BITS
  #define		INT_SIZE			32

#endif



/* Data Type Modifiers: */

#if defined(__TURBOC__)

  #if defined(__BORLANDC__)
    #if __BORLANDC__ >= 0x0400
      /*
       * In Borland C++ 3.1 and on up, the _defs.h system header defines the
       * proper settings for _NEAR, _FAR, and _HUGE.
       */
	   #include <_defs.h>
    #else
      #ifndef _NEAR
        #define		_NEAR		near
      #endif
      #ifndef _FAR
        #define		_FAR		far
      #endif
      #ifndef _HUGE
        #define		_HUGE		huge
      #endif
    #endif
  #else
    #ifndef _NEAR
      #define		_NEAR		near
    #endif
    #ifndef _FAR
      #define		_FAR		far
    #endif
    #ifndef _HUGE
      #define		_HUGE		huge
    #endif
  #endif
  #define		_PACKED

#elif defined(THINK_C)

  #define		_NEAR
  #define		_FAR
  #define		_HUGE
  #define		_PACKED

#elif defined(__i960)

  #define		_NEAR
  #define		_FAR
  #define		_HUGE
  /*
   * The Intel 80960 compiler employs a "noalign" pragma to control data
   * alignment in structures.
   */
  #define		_PACKED

#elif defined(_MCC960)

  #define		_NEAR
  #define		_FAR
  #define		_HUGE
  #define		_PACKED		packed

#elif defined(_MSC_VER)

  #define		_NEAR
  #define		_FAR
  /* Microsoft defines _HUGE in math.h */
  /* #define		_HUGE */
  #define		_PACKED		packed

#elif defined(_TMS340)

  #define		_NEAR
  #define		_FAR
  #define		_HUGE
  /*
   * The 34010 packs everything by default on bit boundries.  Thus you can
   * have a word, followed by a bit field, followed by a word and it will
   * normally pack this.  The BIG exception is floating point numbers.  The 
   * 34010 does not pack floating point numbers.  It always aligns them on
   * 32 or 64 bit boundries because of their coprocessor design.  So you
   * can't have a packed structure if it includes a floating point number.
   */
  #define		_PACKED

#endif



#ifdef  __cplusplus
}
#endif



#endif  /* _stdcompl_ */



/*************************************************************************
*
*   $Log:   L:/common/sw/std/vcs/stdcompl.h_v  $
*   
*      Rev 1.3   07 Nov 1996 11:34:58   HUSTOR
*   Added knowledge of _NEAR, _FAR, and _HUGE data type modifiers.
*   
*      Rev 1.2   07 May 1996 09:55:58   HUSTOR
*   Added "C" external linkage controls for C++.
*   
*      Rev 1.1   25 Oct 1994 10:56:06   HUSTOR
*   Moved 'Tab Setting:' section.
*   
*      Rev 1.0   09 Jun 1994 08:57:18   HUSTOR
*   Initial revision.
*
*************************************************************************/
