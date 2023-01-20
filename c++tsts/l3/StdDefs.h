/*
 *===========================================================================
 *
 *  HEADER FILE:  StdDefs.h
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
 *  $Workfile:   StdDefs.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdDefs.h-arc  $
 *
 *  $Revision:   2.1  $
 *
 *  $Date:   Oct 30 2003 14:57:48  $
 *
 *  $Author:   GeisD  $
 *
 *===========================================================================
 *
 *  Class Overview::
 *
 *  This is one of the 'standard' files automatically included by the
 *  StdIncl.h 'standard' header file for the SIDE.
 *
 *  This header specifies the 'standard' #define's associated with the
 *	 SIDE.
 *
 *  This header contains compiler independent defines.
 *
 *===========================================================================
 */

#ifndef __STDDEFS_H__
#define __STDDEFS_H__

#ifdef __cplusplus
extern "C" {
#endif


   /*
    * End of file indicator:
    */
   #if !defined(EOF)
     #define       EOF             (-1)
   #endif


   /*
    * General answers:
    */
   #if !defined (NO) || !defined (YES) || !defined (DONT_KNOW)
      #define     NO                  0
      #define     YES                 1
      #define     DONT_KNOW           (-1)
   #endif


   /*
    * General error codes:
    */

   #if !defined (__cplusplus)
      #ifdef       ERROR
         #undef    ERROR
         #define   ERROR               (-1)
      #endif
      #ifdef       NO_ERROR
         #undef    NO_ERROR
         #define   NO_ERROR            0
      #endif
   #endif


   /*
    * Bit flags:
    */

   #define     BIT_00              (0x01U)
   #define     BIT_01              (0x02U)
   #define     BIT_02              (0x04U)
   #define     BIT_03              (0x08U)
   #define     BIT_04              (0x10U)
   #define     BIT_05              (0x20U)
   #define     BIT_06              (0x40U)
   #define     BIT_07              (0x80U)
   #define     BIT_08              (0x0100U)
   #define     BIT_09              (0x0200U)
   #define     BIT_10              (0x0400U)
   #define     BIT_11              (0x0800U)
   #define     BIT_12              (0x1000U)
   #define     BIT_13              (0x2000U)
   #define     BIT_14              (0x4000U)
   #define     BIT_15              (0x8000U)
   #define     BIT_16              (0x00010000UL)
   #define     BIT_17              (0x00020000UL)
   #define     BIT_18              (0x00040000UL)
   #define     BIT_19              (0x00080000UL)
   #define     BIT_20              (0x00100000UL)
   #define     BIT_21              (0x00200000UL)
   #define     BIT_22              (0x00400000UL)
   #define     BIT_23              (0x00800000UL)
   #define     BIT_24              (0x01000000UL)
   #define     BIT_25              (0x02000000UL)
   #define     BIT_26              (0x04000000UL)
   #define     BIT_27              (0x08000000UL)
   #define     BIT_28              (0x10000000UL)
   #define     BIT_29              (0x20000000UL)
   #define     BIT_30              (0x40000000UL)
   #define     BIT_31              (0x80000000UL)


   /*
    * Canonical sizes:
    */

   #define     CS_1K               (0x0400U)
   #define     CS_2K               (0x0800U)
   #define     CS_4K               (0x1000U)
   #define     CS_8K               (0x2000U)
   #define     CS_16K              (0x4000U)
   #define     CS_32K              (0x8000U)
   #define     CS_64K              (0x00010000UL)
   #define     CS_128K             (0x00020000UL)
   #define     CS_256K             (0x00040000UL)
   #define     CS_512K             (0x00080000UL)
   #define     CS_1M               (0x00100000UL)
   #define     CS_2M               (0x00200000UL)
   #define     CS_4M               (0x00400000UL)
   #define     CS_8M               (0x00800000UL)
   #define     CS_16M              (0x01000000UL)
   #define     CS_32M              (0x02000000UL)
   #define     CS_64M              (0x04000000UL)
   #define     CS_128M             (0x08000000UL)
   #define     CS_256M             (0x10000000UL)
   #define     CS_512M             (0x20000000UL)
   #define     CS_1G               (0x40000000UL)
   #define     CS_2G               (0x80000000UL)


   /*
    * Miscellaneous Stuff:
    */

   #if !defined(SECONDS_PER_MINUTE)
     #define   SECONDS_PER_MINUTE  (60)
   #endif

   #if !defined(SECONDS_PER_HOUR)
     #define   SECONDS_PER_HOUR    (3600)
   #endif

   #if !defined(SECONDS_PER_DAY)
     #define   SECONDS_PER_DAY     (86400)
   #endif

   #if !defined(SECONDS_PER_WEEK)
     #define   SECONDS_PER_WEEK    (604800)
   #endif
//*/

//DAY ---->>


   #ifndef NULL
      #ifdef __cplusplus
         #define NULL   (0)
      #else
         #define NULL   ((void *)0)
      #endif
   #else
      #undef NULL
      #ifdef __cplusplus
         #define NULL   (0)
      #else
         #define NULL   ((void *)0)
      #endif
   #endif

   #ifndef SUCCESS
   #define SUCCESS            (tStdReturn)(0)
   #else
   #undef  SUCCESS
   #define SUCCESS            (tStdReturn)(0)
   #endif

   #ifndef FAILURE
   #define FAILURE            (tStdReturn)(1)
   #else
   #undef  FAILURE
   #define FAILURE            (tStdReturn)(1)
   #endif

   #define STRINGS_IDENTICAL  ( 0 )   /* strcmp() value returned when test strings are the same */
   #define STRING_MATCH_FOUND ( 0 )

   #define MAX_STRING_25      (  25 )
   #define MAX_STRING_50      (  50 )
   #define MAX_STRING_55      (  55 )
   #define MAX_STRING_70      (  70 )
   #define MAX_STRING_80      (  80 )
   #define MAX_STRING_100     ( 100 )
   #define MAX_STRING_255     ( 255 )
   #define MAX_CHARS_LINE     ( MAX_STRING_255 )
   #define MAX_CHARS_WORD     ( MAX_STRING_80 )

   #define MAX_PATH_LENGTH    ( MAX_STRING_255 ) /* Max length of path string */
   #define FILE_NAME_LENGTH   ( MAX_STRING_80 )

   /*  The following VGA, SVGA, etc. should be removed from implementation and
       removed from this file at some time in the future                       */
   #define VGA_WIDTH_PIXELS   (  640 )
   #define VGA_HEIGHT_PIXELS  (  480 )
   #define SVGA_WIDTH_PIXELS  (  800 )
   #define SVGA_HEIGHT_PIXELS (  600 )
   #define XGA_WIDTH_PIXELS   ( 1024 )
   #define XGA_HEIGHT_PIXELS  (  768 )
   #define SXGA_WIDTH_PIXELS  ( 1280 )
   #define SXGA_HEIGHT_PIXELS ( 1024 )

   #define MAX_WIDTH_PIXELS   SVGA_WIDTH_PIXELS
   #define MAX_HEIGHT_PIXELS  SVGA_HEIGHT_PIXELS


   #define STR_NULL           "\0"                     /*  ( char )NULL?  */
   #define CHAR_NULL          '\0'                     /*  ( char )NULL?  */

   #define WRITE_SMB_TIMEOUT    20   /* Timeout in milliseconds for copy to shared memory */
   #define READ_SMB_TIMEOUT      5   /* Timeout in milliseconds for get from shared memory */

   // define processors
   #define IO_PROCESSOR        0
   #define DISPLAY_PROCESSOR   1

#ifdef  __cplusplus
}
#endif


#endif   /* __STDDEFS_H__  */


/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdDefs.h-arc  $
 * 
 *    Rev 2.1   Oct 30 2003 14:57:48   GeisD
 * Merged in revision 2.0.1.0
 * 
 *    Rev 2.0.1.0   Oct 30 2003 08:33:28   ShellM
 * added processor defines 
 *
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 *
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 *
 *    Rev 1.1   Jan 02 2003 18:04:40   ShellM
 * updated to handle correct c++/c selection of bool types
 *
 *    Rev 1.1   Dec 12 2002 10:18:40   ShellM
 * updated for kernel system integration
 *
 ************************************************************************/
