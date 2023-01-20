/*
 *===========================================================================
 *
 *  HEADER FILE:  StdIncl.h
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
 *  $Workfile:   StdIncl.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdIncl.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:50:04  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 *
 *  Overview:
 *
 *     This is the 'common' header file to be included into each user defined
 *     header ( and/or source file, as needed ).
 *
 *     This header merely 'includes' the other 'standard' header files to
 *     support the SIDE.
 *
 *===========================================================================
 */


//  Protect against multiple includes
#ifndef __STDINCL_H__
#define __STDINCL_H__


#ifdef __cplusplus
extern "C" {
#endif


//Check to see that one of the supported compilers has invoked us
#if !defined(_MSC_VER)   && \
    !defined(__ghs__)    && \
    !defined(__GNUG__)
  #error Supported compiler not found!
#endif



#if defined (__ghs__)	      //compile for GHS
   #include "Integrity.h"
   #include <sys/types.h>

	#include "ghsStdTypes.h"
	#include "ghsStdDefs.h"

#elif defined (__GNUG__)

	#include "gnugStdTypes.h"
	#include "gnugStdDefs.h"

#elif defined (_MSC_VER)	   //compile for MSC
   #include "mscStdCompl.h"    //  define's, pragma's, etc.
   #include "mscStdTypes.h"    //  #typedef's


#endif

//includes for compiler independent headers
#if defined (__ghs__) || defined (_MSC_VER) || defined (__GNUG__)
   #include "StdDefs.h"          //  #define's
   #include "StdTypes.h"         //  #typedef's
   #ifdef __cplusplus
   #include "StdMacros.h"        //  macro's
   #include "StdMathConstants.h" //  conversions to support K class
   #endif
#endif




#ifdef  __cplusplus
}
#endif


#endif   // __STDINCL_H__


/*===========================================================================
 *
 *  Header Revision History
 *
 *  Rev     Date     Designer         Description of Change
 *  ------- -------- ---------------- ---------------------------------------
 *
 *   1.0    05/16/01 Tom Zawodny      Initial Release/Source Code Cleanup Pass
 *
 *===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdIncl.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:58   JohnsT
 * Initial revision.
 * 
 *    Rev 1.1   Dec 12 2002 10:18:40   ShellM
 * updated for kernel system integration
 * 
 *    Rev 1.2   Dec 20 2001 16:50:26   RadloK
 * Post PVCS Project Reconstruction
 * 
 *    Rev 1.1   Sep 21 2001 09:33:24   RadloK
 * Modified for Standardized Method Return type
 * 
 *    Rev 1.0   Jul 05 2001 12:02:58   BrainL
 * Initial revision.
 *
 *===========================================================================
 

 *****  END of HEADER  *****

 */
