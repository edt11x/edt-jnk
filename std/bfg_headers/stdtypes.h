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
*   $Workfile:   stdtypes.h  $
*
*    $Archive:   L:/common/sw/std/vcs/stdtypes.h_v  $
*   $Revision:   1.4  $
*       $Date:   07 May 1996 09:55:58  $
*     $Author:   HUSTOR  $
*
*   Originally created by Robert S. Huston
*   June 9, 1994
*
*   Tab Setting:  4
*
*   Standard data types.
*
*   The following compilers are currently supported:
*       __TURBOC__      Borland's Turbo C (and C++) for the PC
*       THINK_C         Symantec's THINK C for the Macintosh
*       _MCC960         Microtec's MCC960 for the PC
*       __i960          Intel's iC-960 for the PC
*       _TMS340         TI's GSPCC for the PC
*       _MSC_VER        Microsoft Visual C++ 6.0
*
*************************************************************************/

#if !defined(_stdtypes_)
#define _stdtypes_



#ifdef __cplusplus
extern "C" {
#endif



/*
 *
 * Check to see that one of the supported compilers has invoked us.
 *
 */

#if !defined(__TURBOC__) && \
    !defined(THINK_C)    && \
    !defined(_MCC960)    && \
    !defined(__i960)     && \
    !defined(_TMS340)    && \
    !defined(_MSC_VER)
  #error Supported compiler not found!
#endif



/* Standard data types: */

#if defined(__TURBOC__)

  typedef char				byte;			/* 8 bit value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit value */
  typedef unsigned short	uword;			/* 16 bit unsignedvalue */
  typedef long				dword;			/* 32 bit value */
  typedef unsigned long		udword;			/* 32 bit unsignedvalue */
  typedef float				real;			/* 32 bit floating-pointvalue */
  typedef double			dreal;			/* 64 bit floating-pointvalue */
  typedef long double		ereal;			/* 80 bit floating-pointvalue */

  enum boolean {
 		 false = 0, true  = 1,
		 False = 0, True  = 1,
		 FALSE = 0, TRUE  = 1
  };
  typedef enum boolean	boolean;

#elif defined(THINK_C)

  typedef char				byte;			/* 8 bit signed value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit signed value */
  typedef unsigned short	uword;			/* 16 bit unsigned value */
  typedef long				dword;			/* 32 bit signed value */
  typedef unsigned long		udword;			/* 32 bit unsigned value */
  typedef float				real;			/* 32 bit floating-point value */
  #if __option(double_8)
    typedef double			dreal;			/* 64 bit floating-point value */
    typedef long double		ereal;			/* 80 bit floating-point value */
  #else
    typedef short double	dreal;			/* 64 bit floating-point value */
    typedef double			ereal;			/* 80 bit floating-point value */
  #endif

  enum boolean {
 		 false = 0, true  = 1,
		 False = 0, True  = 1,
		 FALSE = 0, TRUE  = 1
  };
  typedef enum boolean	boolean;

#elif defined(__i960)

  typedef char				byte;			/* 8 bit value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit value */
  typedef unsigned short	uword;			/* 16 bit unsignedvalue */
  typedef long				dword;			/* 32 bit value */
  typedef unsigned long		udword;			/* 32 bit unsignedvalue */
  typedef float				real;			/* 32 bit floating-pointvalue */
  typedef double			dreal;			/* 64 bit floating-pointvalue */
  typedef long double		ereal;			/* 80 bit floating-pointvalue */

  enum boolean {
 		 false = 0, true  = 1,
		 False = 0, True  = 1,
		 FALSE = 0, TRUE  = 1
  };
  typedef enum boolean	boolean;

#elif defined(_MCC960)

  typedef char				byte;			/* 8 bit value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit value */
  typedef unsigned short	uword;			/* 16 bit unsignedvalue */
  typedef long				dword;			/* 32 bit value */
  typedef unsigned long		udword;			/* 32 bit unsignedvalue */
  typedef float				real;			/* 32 bit floating-pointvalue */
  typedef double			dreal;			/* 64 bit floating-pointvalue */
  typedef long double		ereal;			/* 80 bit floating-pointvalue */

  enum boolean {
 		 false = 0, true  = 1,
		 False = 0, True  = 1,
		 FALSE = 0, TRUE  = 1
  };
  typedef enum boolean	boolean;

#elif defined(_MSC_VER)

  /* Microsoft defines byte as unsigned char */
  /* typedef char				byte; */			/* 8 bit value */
  typedef unsigned char		byte;			/* 8 bit value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit value */
  typedef unsigned short	uword;			/* 16 bit unsignedvalue */
  typedef long				dword;			/* 32 bit value */
  typedef unsigned long		udword;			/* 32 bit unsignedvalue */
  typedef float				real;			/* 32 bit floating-pointvalue */
  typedef double			dreal;			/* 64 bit floating-pointvalue */
  typedef long double		ereal;			/* 80 bit floating-pointvalue */

  typedef unsigned char         boolean;

#ifdef NEVER

  /* Microsoft defines boolean as unsigned char */
  enum boolean {
  		 false = 0, true  = 1,
  		 False = 0, True  = 1,
  		 FALSE = 0, TRUE  = 1
  };
  typedef enum boolean	boolean;
#endif /* NEVER */


#elif defined(_TMS340)

  typedef char				byte;			/* 8 bit value */
  typedef unsigned char		ubyte;			/* 8 bit unsigned value */
  typedef short				word;			/* 16 bit value */
  typedef unsigned short	uword;			/* 16 bit unsignedvalue */
  typedef long				dword;			/* 32 bit value */
  typedef unsigned long		udword;			/* 32 bit unsignedvalue */
  typedef float				real;			/* 32 bit floating-pointvalue */
  typedef double			dreal;			/* 64 bit floating-pointvalue */
  typedef long double		ereal;			/* 80 bit floating-pointvalue */

  typedef unsigned short	boolean;
  #define FALSE			(0)
  #define TRUE			(1)
  #define False			(0)
  #define True			(1)
  #define false			(0)
  #define true			(1)

#endif


/* Pointer types: */

typedef void				*voidPtr;
typedef byte				*bytePtr;
typedef ubyte				*ubytePtr;
typedef word				*wordPtr;
typedef uword				*uwordPtr;
typedef dword				*dwordPtr;
typedef udword				*udwordPtr;
typedef real				*realPtr;
typedef dreal				*drealPtr;
typedef ereal				*erealPtr;
typedef	boolean				*booleanPtr;


/* Handle types: */

typedef voidPtr				*voidHdl;
typedef bytePtr				*byteHdl;
typedef ubytePtr			*ubyteHdl;
typedef wordPtr				*wordHdl;
typedef uwordPtr			*uwordHdl;
typedef dwordPtr			*dwordHdl;
typedef udwordPtr			*udwordHdl;
typedef realPtr				*realHdl;
typedef drealPtr			*drealHdl;
typedef erealPtr			*erealHdl;
typedef	booleanPtr			*booleanHdl;


/* Binary-Angle-Measure types:
 *
 * Binary-Angle-Measure (BAMS) notation is a way to represent a angular
 * measurement from 0 to 360 degrees scaled in terms of an integer from 
 * 0 to the maximum resolution of the BAMS.  The maximum value for BAMS8
 * is 256 (2^8), for BAMS16 is 65536 (2^16), and for BAMS32 is 4294967296
 * (2^32).  For example:
 *
 *   BAMS8 value of 127 (0x7F) = (127 / 256) * 360 = 178.59375 degrees
 */

typedef ubyte				bams8;			/* 8 bit bams value */
typedef uword				bams16;			/* 16 bit bams value */
typedef udword				bams32;			/* 32 bit bams value */


/* Funny string types: */

#if defined(THINK_C)

  						 /* Str255 is already defined for us in Types.h. */
  typedef ubyte				Str127[128];	/* 127 byte string + '\0' */
  						 /* Str63 is already defined for us in Types.h. */
  typedef ubyte				Str31[32];		/* 31 byte string + '\0' */
  typedef ubyte				Str15[16];		/* 15 byte string + '\0' */
  						 /* StringPtr is already defined for us in Types.h. */

#else

  typedef ubyte				Str255[256];	/* 255 byte string + '\0' */
  typedef ubyte				Str127[128];	/* 127 byte string + '\0' */
  typedef ubyte				Str63[64];		/* 63 byte string + '\0' */
  typedef ubyte				Str31[32];		/* 31 byte string + '\0' */
  typedef ubyte				Str15[16];		/* 15 byte string + '\0' */
  typedef ubyte				*StringPtr;		/* Pointer to a string */

#endif



#ifdef  __cplusplus
}
#endif



#endif /* _stdtypes_ */



/*************************************************************************
*
*   $Log:   L:/common/sw/std/vcs/stdtypes.h_v  $
*   
*      Rev 1.4   07 May 1996 09:55:58   HUSTOR
*   Added "C" external linkage controls for C++.
*   
*      Rev 1.3   30 Apr 1996 08:31:36   HUSTOR
*   Added Str31, Str15, and StringPtr types.
*   
*      Rev 1.2   25 Oct 1994 10:56:08   HUSTOR
*   Moved 'Tab Setting:' section.
*   
*      Rev 1.1   07 Jul 1994 09:48:00   HUSTOR
*   Moved fixed typedefs to fixmath.h
*   
*      Rev 1.0   09 Jun 1994 08:57:20   HUSTOR
*   Initial revision.
*
*************************************************************************/
