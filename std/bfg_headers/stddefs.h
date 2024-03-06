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
*   $Workfile:   stddefs.h  $
*
*    $Archive:   L:/common/sw/std/vcs/stddefs.h_v  $
*   $Revision:   1.3  $
*       $Date:   07 May 1996 09:55:58  $
*     $Author:   HUSTOR  $
*
*   Originally created by Robert S. Huston
*   June 9, 1994
*
*   Tab Setting:  4
*
*   Standard definitions.
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

#if !defined(_stddefs_)
#define _stddefs_



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



/* NULL and NIL and friends: */

#if !defined(NULL) && !defined(__cplusplus)

  #if defined(__TURBOC__)
 
    #if defined(__TINY__) || defined(__SMALL__) || defined(__MEDIUM__)
      #define	NULL			(0)
    #else
      #define	NULL			(0L)
    #endif
 
  #elif defined(THINK_C)
 
    #define		NULL			((void *) 0)
 
  #elif defined(__i960)
 
    #define		NULL			((void *) 0)
 
  #elif defined(_MCC960)
 
    #define		NULL			((void *) 0)
 
  #elif defined(_MSC_VER)
 
    #define		NULL			((void *) 0)
 
  #elif defined(_TMS340)
 
    #define		NULL			((void *) 0)
 
  #endif

#endif


#if !defined(NIL)
  #define		NIL				NULL		/* For Pascal weenies */
#endif
 

/* End of file indicator: */

#if !defined(EOF)
  #define		EOF				(-1)
#endif
 

/* General answers: */

#define		NO					0
#define		YES					1
#define		DONT_KNOW			(-1)

/* General error codes: */

#if !defined(_MSC_VER) || !defined(__cplusplus)
#define		NO_ERROR			0
#define		ERROR				(-1)
#endif /* #if !defined(_MSC_VER) || !defined(_cplusplus) */


/* Bit flags: */

#define		BIT_00				(0x01U)
#define		BIT_01				(0x02U)
#define		BIT_02				(0x04U)
#define		BIT_03				(0x08U)
#define		BIT_04				(0x10U)
#define		BIT_05				(0x20U)
#define		BIT_06				(0x40U)
#define		BIT_07				(0x80U)
#define		BIT_08				(0x0100U)
#define		BIT_09				(0x0200U)
#define		BIT_10				(0x0400U)
#define		BIT_11				(0x0800U)
#define		BIT_12				(0x1000U)
#define		BIT_13				(0x2000U)
#define		BIT_14				(0x4000U)
#define		BIT_15				(0x8000U)
#define		BIT_16				(0x00010000UL)
#define		BIT_17				(0x00020000UL)
#define		BIT_18				(0x00040000UL)
#define		BIT_19				(0x00080000UL)
#define		BIT_20				(0x00100000UL)
#define		BIT_21				(0x00200000UL)
#define		BIT_22				(0x00400000UL)
#define		BIT_23				(0x00800000UL)
#define		BIT_24				(0x01000000UL)
#define		BIT_25				(0x02000000UL)
#define		BIT_26				(0x04000000UL)
#define		BIT_27				(0x08000000UL)
#define		BIT_28				(0x10000000UL)
#define		BIT_29				(0x20000000UL)
#define		BIT_30				(0x40000000UL)
#define		BIT_31				(0x80000000UL)

/* Canonical sizes: */

#define		CS_1K				(0x0400U)
#define		CS_2K				(0x0800U)
#define		CS_4K				(0x1000U)
#define		CS_8K				(0x2000U)
#define		CS_16K				(0x4000U)
#define		CS_32K				(0x8000U)
#define		CS_64K				(0x00010000UL)
#define		CS_128K				(0x00020000UL)
#define		CS_256K				(0x00040000UL)
#define		CS_512K				(0x00080000UL)
#define		CS_1M				(0x00100000UL)
#define		CS_2M				(0x00200000UL)
#define		CS_4M				(0x00400000UL)
#define		CS_8M				(0x00800000UL)
#define		CS_16M				(0x01000000UL)
#define		CS_32M				(0x02000000UL)
#define		CS_64M				(0x04000000UL)
#define		CS_128M				(0x08000000UL)
#define		CS_256M				(0x10000000UL)
#define		CS_512M				(0x20000000UL)
#define		CS_1G				(0x40000000UL)
#define		CS_2G				(0x80000000UL)



#ifdef  __cplusplus
}
#endif



#endif /* _stddefs_ */



/*************************************************************************
*
*   $Log:   L:/common/sw/std/vcs/stddefs.h_v  $
*   
*      Rev 1.3   07 May 1996 09:55:58   HUSTOR
*   Added "C" external linkage controls for C++.
*   
*      Rev 1.2   25 Oct 1994 10:56:06   HUSTOR
*   Moved 'Tab Setting:' section.
*   
*      Rev 1.1   30 Aug 1994 07:23:34   HUSTOR
*   Added EOF, in case you don't want to #include <stdio.h> all the time.
*   
*      Rev 1.0   09 Jun 1994 08:57:18   HUSTOR
*   Initial revision.
*
*************************************************************************/
