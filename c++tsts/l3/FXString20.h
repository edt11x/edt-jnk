/*
 *===========================================================================
 */
/** \file  FXString20.h
 *
 *
 */
/*===========================================================================
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
 *  Copyright (c), Goodrich Avionics Systems, Incorporated.
 *  All rights reserved.
 *
 *===========================================================================
 *
 *  $Workfile:   FXString20.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers/FXString20.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:48:54  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 */
/** \class FXString20.h
 *
 *  This class will provide us with the necessary information to create a  <br>
 *  fixed length string with a buffer size of 20 plus an additional space for  <br>
 *  the NULL character.
 *
 *===========================================================================
 */

//  Protect against multiple includes
#ifndef __FXSTRING20_H__
#define __FXSTRING20_H__

//  System Header File(s)
// None

//  Standard Header File(s)
#include "StdIncl.h"

//  User-Defined Header(s)
#include "FXString.h"

//  Symbolic Constant(s)
#define FXSTRING20_SIZE   20

//  Macro Define(s)
//  None

//  Enumerated Type(s)
//  None

// Class definition
class FXString20: public FXString
{
   //  Public, Protected, and Private Attributes Section
   public:
      // None
      
   private:
      char szBuffer[ FXSTRING20_SIZE+1 ];  /**< the plus one is for the NULL character */
      static char *pszVCSId;               /**< Source ID Track Number */

   protected:
      // None

   //  Public, Protected, and Private Methods Section
   public:
      FXString20();

      FXString20(const char *pszString);
      FXString20(const FXString20 &fxsString);

     ~FXString20();

   private:
      // None

   protected:
      // None

};

#endif //__FXSTRING20_H__

/*===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers/FXString20.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:48:54   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:41:58   JohnsT
 * Initial revision.
 * 
 *    Rev 1.1   Feb 21 2003 14:01:18   ParsoT
 * Updated / merged from FDS
 * 
 *    Rev 1.3   Nov 06 2002 12:28:36   McCluR
 * Added conversion methods.
 * Fixed bugs found in reverse(), concat, copyN.
 * Fixed concat and copyN to not copy self.
 * Updated Doxygenation.
 * Resolution for 113: Add Coversion Methods to FXString
 * Resolution for 128: The FXString classes need these updates
 * Resolution for 129: FXString needs rework
 * 
 *    Rev 1.2   Nov 01 2002 14:56:58   McCluR
 * added a copy constructor and a const char * constructor
 * 
 *    Rev 1.1   Oct 23 2002 09:56:16   MccluJ
 * changing header to include doxygen code
 * 
 *    Rev 1.0   Jul 24 2002 15:04:02   GeisD
 * Initial Revision
 * 
 *===========================================================================

 
 *****  END of HEADER  *****
  
 */
