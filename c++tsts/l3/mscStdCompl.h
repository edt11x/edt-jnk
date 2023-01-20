/*
 *===========================================================================
 *
 *  HEADER FILE:  mscStdCompl.h
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
 *  $Workfile:   mscStdCompl.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/mscStdCompl.h-arc  $
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
 *  This header specifies the 'standard' define's, pragma's, etc. associated
 *  with the SIDE.
 *
 *     NOTE: The contents of this file were borrowed from the Columbus
 *           office.  Their 'original' file was pared down to only reference
 *           the MicroSoft C++ compiler.  Should this file need to support
 *           other development environments, this file should be expanded to
 *           account for it.
 *
 *  This file is specifically for the Microsoft compiler.
 *
 *===========================================================================
 */

#ifndef __MSCSTDCOMPL_H__
#define __MSCSTDCOMPL_H__


#ifdef __cplusplus
extern "C" {
#endif


   #define       LITTLE_ENDIAN       /* Right-to-left addressing */
   #define       INTS_R_32_BITS
   #define       INT_SIZE            32

   #define       _NEAR
   #define       _FAR
   /* Microsoft defines _HUGE in math.h */
   /* #define        _HUGE */
   /* Visual C++ 6.0 (_MSC_VER == 1200) doesn't have the 'packed' keyword */
   #if _MSC_VER >= 1200
     #define     _PACKED
   #else
     #define     _PACKED     packed
   #endif


#ifdef  __cplusplus
}
#endif


#endif   /* __MSCSTDCOMPL_H__  */


/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/mscStdCompl.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:46   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 12 2002 10:17:36   ShellM
 * Initial revision.
 * 
 ************************************************************************/
