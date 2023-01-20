/*
 *===========================================================================
 */
/** \file  FXString.h 
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
 *  $Workfile:   FXString.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers/FXString.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:48:52  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 */
/** \class  FXString.h 
 *
 *  This class provides the methods necessary for manipulating a variable-  <br>
 *  length string with a fixed maximum length.  The FXString class can not be <br>
 *  instantiated; only classes that inherit from FXString can actually be  <br>
 *  instantiated.
 *
 *===========================================================================
 */

//  Protect against multiple includes
#ifndef __FXSTRING_H__
#define __FXSTRING_H__

//  System Header File(s)
#include <string.h>  //B4I
#include <ctype.h>   //B4I
#include <stdio.h>   //B4I

//  Standard Header File(s)
#include "StdIncl.h"

//  User-Defined Header(s)
// None

//  Symbolic Constant(s)
// None

// Pre-ErrorCode Definitions
#define EFXS_EXCEEDS_MAX_LENGTH 1
#define EFXS_NULL_POINTER       2
#define EFXS_NULL_CHARACTER     3

//  Macro Define(s)

//  Enumerated Type(s)


// Class definition
class FXString
{
   //  Public, Protected, and Private Attributes Section
   public:
      // None
      
   private:
      char   szComment[MAX_CHARS_LINE];  /**< NOTE: removed from methods for optimization purposes */
      char  *pcCurToken;                  /**< keeps track of the current token for strTok */
      static char *pszVCSId;             /**< Source ID Track Number */

   protected:
      char   *pszBuffer;
      uint16 ui2MaxLength;
      uint16 ui2Length;                    /**< i2MaxLength - 1 or max length excluding the NULL character */

   //  Public, Protected, and Private Methods Section
   public:
     ~FXString();

      // accessors
      const char *getBuffer     ( void ) const;
      uint16      getFixedLength( void ) const;
      uint16      length        ( void ) const;

      // case altering methods
      tStdReturn  toUp ( void );
      tStdReturn  toLow( void );
      
      // copy methods
      tStdReturn  copy ( const FXString &fxStr );
      tStdReturn  copy ( const char *pszString );
      tStdReturn  copy ( char cCharacter );
      tStdReturn  copyN( const FXString &fxStr, int16 i2Count );
      tStdReturn  copyN( const char *pszString, int16 i2Count );

      // concat methods
      tStdReturn  concat ( const FXString &fxStr );
      tStdReturn  concat ( const char *pszString );
      tStdReturn  concat ( char cCharacter );
      tStdReturn  concatN( const FXString &fxStr, int16 i2Count );
      tStdReturn  concatN( const char *pszString, int16 i2Count );

      // compare methods -> Case-Sensitive
      int16 compare ( const FXString &fxStr ) const;
      int16 compare ( const char *pszString ) const;
      int16 compare ( char cCharacter ) const;
      int16 compareN( const FXString &fxStr, int16 i2Count ) const;
      int16 compareN( const char *pszString, int16 i2Count ) const;

      // compare methods -> NoT cAsE-sEnSiTiVe
      int16 compareI ( const FXString &fxStr ) const;
      int16 compareI ( const char *pszString ) const;
      int16 compareI ( char cCharacter ) const;
      int16 compareNI( const FXString &fxStr, int16 i2Count ) const;
      int16 compareNI( const char *pszString, int16 i2Count ) const;

      // methods to find a substring
      int inStr( const FXString &fxStr, uint16 i2Position = 0 ) const;
      int inStr( const char *pszString, uint16 i2Position = 0 ) const;
      int inStr( char cCharacter,       uint16 i2Position = 0 ) const;

      // substring methods
      tStdReturn left( uint16 ui2LeftLength );
      tStdReturn left( uint16 ui2LeftLength, const char* pszStr );
      tStdReturn left( uint16 ui2LeftLength, const FXString &fxStr );
      tStdReturn right( uint16 ui2RightLength );
      tStdReturn right( uint16 ui2RightLength, const char* pszStr );
      tStdReturn right( uint16 ui2RightLength, const FXString &fxStr );
      tStdReturn mid( uint16 ui2Start, uint16 ui2MidLength );
      tStdReturn mid( uint16 ui2Start, uint16 ui2MidLength, const char* pszStr );
      tStdReturn mid( uint16 ui2Start, uint16 ui2MidLength, const FXString &fxStr );

      // conversion methods
      tStdReturn getBoolean( bool *pbValue ) const;
      tStdReturn getDouble( double *pdValue ) const;
      tStdReturn getHex( int *piValue ) const;
      tStdReturn getInt( int *piValue ) const;
      tStdReturn getLong( long int *pliValue ) const;

      tStdReturn setBoolean( bool bValue );
      tStdReturn setDouble( double dValue, char *pszFormat = "" );
      tStdReturn setHex( int iValue, char *pszFormat = "" );
      tStdReturn setInt( int iValue, char *pszFormat = "" );
      tStdReturn setLong( long int liValue, char *pszFormat );
     
      // separate string by token
      tStdReturn  strTok( char* pszThisToken, const char* pszDelim );
      void        resetTok( void );

      // miscellaneous methods
      void clearBuffer();  // clears the buffer space
      void reverse();
      char getAt( uint16 ui2Location ) const;
      tStdReturn setAt( uint16  ui2Location, char  cCharacter );
      FXString& operator=( const FXString &rhs);

      // data conversion methods
      int32 atoi() const;
      tStdReturn itoa( int32 i4IntegerToConvert );

   private:

   protected:
      FXString();  // NOTE: This will prohibit instances of FXString from being created

};

#endif // __FXSTRING_H__

/*===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers/FXString.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:48:52   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:41:58   JohnsT
 * Initial revision.
 * 
 *    Rev 1.2   Mar 28 2003 16:08:28   ParsoT
 * Integrity safer.  Todd last week.
 * 
 *    Rev 1.1   Feb 21 2003 14:01:16   ParsoT
 * Updated / merged from FDS
 * 
 *    Rev 1.6   Nov 12 2002 13:19:22   McCluR
 * Added getLong and setLong conversions.  The ConfigReader classes needed them.
 * 
 *    Rev 1.5   Nov 07 2002 15:45:12   McCluR
 * fixed default params in the conversion methods.
 * 
 *    Rev 1.4   Nov 06 2002 12:28:30   McCluR
 * Added conversion methods.
 * Fixed bugs found in reverse(), concat, copyN.
 * Fixed concat and copyN to not copy self.
 * Updated Doxygenation.
 * Resolution for 113: Add Coversion Methods to FXString
 * Resolution for 128: The FXString classes need these updates
 * Resolution for 129: FXString needs rework
 * 
 *    Rev 1.3   Nov 05 2002 11:55:46   McCluR
 * Added additional left, mid and right methods.
 * Fixed inStr to return an index instead of a pointer.
 * Removed clean() method.  Made the clearBuffer method pulbic.  should use that now.
 * Removed the base copy constructor.  Couldn't be called anyway.
 * 
 *    Rev 1.2   Nov 01 2002 14:56:58   McCluR
 * added a copy constructor and a const char * constructor
 * 
 *    Rev 1.1   Oct 23 2002 09:26:00   MccluJ
 * changing header to include doxygen code
 * 
 *    Rev 1.0   Jul 24 2002 15:04:00   GeisD
 * Initial Revision
 * 
 *===========================================================================

 
 *****  END of HEADER  *****
  
 */
