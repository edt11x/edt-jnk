/*
*==============================================================================
*
*	HEADER FILE:	config.h
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
*	$Workfile:   config.h  $
*
*	$Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/config.h-arc  $
*
*	$Revision:   2.0  $
*
*	$Date:   Sep 03 2003 15:50:02  $
*
*	$Author:   JohnsT  $
*
*==============================================================================
*
*	Overview:	This is the configuration header file for SmartDeck.
*
*==============================================================================
*/

#if !defined(_config_)
#define _config_

#ifdef __cplusplus
extern "C" {
#endif


/*
 * Standard BFGAS common #includes:
 */

//Check to see that one of the supported compilers has invoked us
#if !defined(_MSC_VER)   && \
    !defined(__ghs__)
  #error Supported compiler not found!
#endif


#if defined (__ghs__)	      //compile for GHS
   #include "Integrity.h"
   #include <sys/types.h>

	#include "ghsStdTypes.h"
	#include "ghsStdDefs.h"

#elif defined (_MSC_VER)	   //compile for MSC
   #include "mscStdCompl.h"    //  define's, pragma's, etc.
   #include "mscStdTypes.h"    //  #typedef's


#endif

//includes for compiler independent headers
#if defined (__ghs__) || defined (_MSC_VER)
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


#endif /* _config_ */






/*************************************************************************
*
*   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/config.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:10   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:40   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 12 2002 10:17:32   ShellM
 * Initial revision.
 * 
 *    Rev 1.1   Jun 05 2002 13:16:54   GreggJ
 * Removed the #define for __GHS and replaced other references to it with __ghs__.
 * 
 *    Rev 1.0   May 31 2002 11:06:36   HalljA
 * Initial revision.
*   
*************************************************************************/
