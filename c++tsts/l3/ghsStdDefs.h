/*
 *===========================================================================
 *
 *  HEADER FILE:  ghsStdDefs.h
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
 *  $Workfile:   ghsStdDefs.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/ghsStdDefs.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:50:02  $
 *
 *  $Author:   JohnsT  $
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
 *  This header is specifically for the Green Hills Integrity OS and compiler
 *
 *
 *===========================================================================
 */


#ifndef __GHSSTDDEFS_H__
#define __GHSSTDDEFS_H__

#ifdef __cplusplus
extern "C" {
#endif


//*.** Integrity mods **.*/

   /* create our own MS compatible defines */
   #define INFINITE 65535

   static int FILE_MAP_READ = 0x0001;
   static int FILE_MAP_WRITE = 0x0002;
 
   #define  WAIT_OBJECT_0	( 0 ) /* The state of the specified object is signaled. */
   #define  WAIT_TIMEOUT	( 1 ) /* The time-out interval elapsed, and the object's state is nonsignaled. */
   #define  WAIT_ABANDONED	( 2 ) /* The specified object is a mutex object that was not released by the thread that owned the mutex object before the owning thread terminated. Ownership of the mutex object is granted to the calling thread, and the mutex is set to nonsignaled. */
   #define  WAIT_FAILED		( 3 ) /* The specified object is a mutex object that was not released by the thread that owned the mutex object before the owning thread terminated. Ownership of the mutex object is granted to the calling thread, and the mutex is set to nonsignaled. */



#ifdef  __cplusplus
}
#endif



#endif   /* __GHSSTDDEFS_H__  */


/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/ghsStdDefs.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:10   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:42   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 12 2002 10:17:34   ShellM
 * Initial revision.
 * 
 ************************************************************************/

 
