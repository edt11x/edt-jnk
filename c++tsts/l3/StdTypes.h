/*
*==============================================================================
*
*	HEADER FILE:	stdtypes.h
*
*==============================================================================
*
*	Goodrich Avionics Systems, Inc.
*	P.O. Box 873
*	5353 52nd St. SE
*	Grand Rapids, MI  49588-0873
*	(616) 949-6600
*
*==============================================================================
*
*	This file contains proprietary information. This file shall not be
*	duplicated, used, modified, or disclosed in whole or in part without
*	the express written consent of Goodrich Avionics Systems, Inc.
*
*	Copyright (c) 1997-2002, Goodrich Avionics Systems, Inc.
*	All rights reserved.
*
*==============================================================================
*
*	$Workfile:   StdTypes.h  $
*
*	$Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdTypes.h-arc  $
*
*	$Revision:   2.0.1.0  $
*
*	$Date:   Sep 26 2003 12:38:20  $
*
*	$Author:   GeisD  $
*
*==============================================================================
*
*	Overview:	This is the header file for standard data types.
*              This file is compiler independent.
*
*==============================================================================
*
*   The following compilers are currently supported:
*       _MSC_VER        Microsoft Visual C++ 6.0
*		  __ghs__			Green Hills C/C++ Compiler
*		
*
*==============================================================================
*/

#ifndef __STDTYPES_H__
#define __STDTYPES_H__

#ifdef __cplusplus
extern "C" {
#endif



   /*
    * Pointer types:
    */

   typedef void                *voidPtr;
   typedef byte                *bytePtr;
   typedef ubyte               *ubytePtr;
   typedef word                *wordPtr;
   typedef uword               *uwordPtr;
   typedef dword               *dwordPtr;
   typedef udword              *udwordPtr;
   typedef real                *realPtr;
   typedef dreal               *drealPtr;
   typedef ereal               *erealPtr;
   typedef boolean             *booleanPtr;

   /*
    * Structures
    */

   typedef struct
   {
       uint8 ui1Status;
       char cData;
   } charRecord;
   
   typedef struct
   {
       uint8 ui1Status;
       boolean bData;
   } boolRecord;
   
   typedef struct 
   {
      uint8 ui1Status;
      real32 fData;
   } real32Record;

   typedef struct
   {
      uint8 ui1Status;
      real64 dData;
   } real64Record;

   typedef struct
   {
      uint8 ui1Status;
      real80 xData;
   } real80Record;
  

   typedef struct
   {
      uint8 ui1Status;
      uint8 ui1Data;
   } uint8Record;
    
   typedef struct
   {
      uint8 ui1Status;
      uint16 ui2Data;
   } uint16Record;

   typedef struct
   {
      uint8 ui1Status;
      uint32 ui4Data;
   } uint32Record;

  typedef struct
  {
      uint8 ui1Status;
      uint64 ui8Data;
  } uint64Record;

  
   typedef struct
   {
      uint8 ui1Status;
      int8 i1Data;
   } int8Record;
    
   typedef struct
   {
      uint8 ui1Status;
      int16 i2Data;
   } int16Record;

   typedef struct
   {
      uint8 ui1Status;
      int32 i4Data;
   } int32Record;

  typedef struct
  {
      uint8 ui1Status;
      int64 i8Data;
  } int64Record;


#ifdef  __cplusplus
}
#endif


#endif   /* __STDTYPES_H__  */


/*************************************************************************
*
*   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdTypes.h-arc  $
 * 
 *    Rev 2.0.1.0   Sep 26 2003 12:38:20   GeisD
 * Added structures to be used in SMBs.
 * 
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:14   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:35:04   JohnsT
 * Initial revision.
 * 
 *    Rev 1.1   Dec 12 2002 10:18:42   ShellM
 * updated for kernel system integration
 * 
 *    Rev 1.1   Jun 05 2002 13:18:40   GreggJ
 * Replaced all occurrances of __GHS with __ghs__.
 * 
 *    Rev 1.0   May 31 2002 11:00:46   HalljA
 * Initial revision.
*   
*
*************************************************************************/
