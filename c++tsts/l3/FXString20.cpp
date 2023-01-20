/*
 *===========================================================================
 */
/** \file  FXString20.cpp
 * 
 *  This class will provide us with the necessary information to create a
 *  fixed length string with a buffer size of 20 plus an additional space for
 *  the NULL character.
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
 *  $Workfile:   FXString20.cpp  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Source/FXString20.cpp-arc  $ 
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:49:02  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 *
 *  Project:  SmartDeck
 *
 *  Software Design Description Reference:  TODO: Document No., Paragraph No.
 *
 *===========================================================================
 *
 *
 *  Method List:
 *
 *                FXString20();
 *               ~FXString20();
 *
 *===========================================================================
 */

//  System Header File(s)
// None 

//  User-Defined Header File(s)
//TEPEM #include "EM.h"

//  Companion Header File for This Class
#include "FXString20.h"

//  Source ID Tracking Number
char *FXString20::pszVCSId = "$Header";

//  Module Symbolic Constant(s)
// None 

// Macro Define(s)
// None 


// Enumerated Type(s)
// None

/*  
 *===========================================================================
 */
/** \fn FXString20::FXString20
 *
 *  This routine provides the constructor method.   It initializes the class
 *  at creation.
 *
 *  \param None
 *
 *  \return None
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
FXString20::FXString20()
{
   szBuffer[0] = '\0';
   pszBuffer   = &szBuffer[0];
   ui2MaxLength = FXSTRING20_SIZE+1;  // the plus one is for the NULL character
   ui2Length    = FXSTRING20_SIZE;
}


/*  
 *===========================================================================
 */
/** \fn FXString20::FXString20
 *
 *   TODO:  Provide a description here.   
 *
 *  \param    None 
 *
 *  \return   None
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
FXString20::FXString20(const char *pszString)
{
   pszBuffer   = &szBuffer[0];
   ui2MaxLength = FXSTRING20_SIZE+1;  // the plus one is for the NULL character
   ui2Length    = FXSTRING20_SIZE;

   copy(pszString);
}


/*  
 *===========================================================================
 */
/** \fn FXString20::FXString20
 *
 *   TODO:  Provide a description here.   
 *
 *  \param    None 
 *
 *  \return   None
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
FXString20::FXString20(const FXString20 &fxsString)
{
   pszBuffer   = &szBuffer[0];
   ui2MaxLength = FXSTRING20_SIZE+1;  // the plus one is for the NULL character
   ui2Length    = FXSTRING20_SIZE;

   copy(fxsString);
}


/*  
 *===========================================================================
 */
/** \fn FXString20::~FXString20
 *
 *  This routine provides the destructor method.   It initializes the class
 *  at creation.
 *
 *  \param None
 *
 *  \return None
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
FXString20::~FXString20()
{
}


/*===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Source/FXString20.cpp-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:49:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:42:08   JohnsT
 * Initial revision.
 * 
 *    Rev 1.2   Mar 28 2003 16:08:04   ParsoT
 * Integrity safer.  Todd last week.
 * 
 *    Rev 1.1   Feb 21 2003 13:35:26   ParsoT
 * Updated / merged from FDS
 * 
 *    Rev 1.4   Nov 06 2002 12:28:22   McCluR
 * Added conversion methods.
 * Fixed bugs found in reverse(), concat, copyN.
 * Fixed concat and copyN to not copy self.
 * Updated Doxygenation.
 * Resolution for 113: Add Coversion Methods to FXString
 * Resolution for 128: The FXString classes need these updates
 * Resolution for 129: FXString needs rework
 * 
 *    Rev 1.3   Nov 01 2002 14:57:00   McCluR
 * added a copy constructor and a const char * constructor
 * 
 *    Rev 1.2   Oct 08 2002 08:41:56   KimmeB
 * Replace file and module headers with the Doxygen version.
 * 
 *    Rev 1.1   Jul 24 2002 15:07:32   GeisD
 * Made position of braces consistent.
 * 
 *    Rev 1.0   Jul 24 2002 14:49:12   GeisD
 * Initial Revision
 * 
 *===========================================================================


 *****  END of MODULE  *****

 */
