/*
 *===========================================================================
 */
/** \file FXString.cpp
 *
 *  This class provides the methods necessary for manipulating a variable-
 *  length string with a fixed maximum length.  The FXString class can not be 
 *  instantiated; only classes that inherit from FXString can actually be 
 *  instantiated.
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
 *  $Workfile:   FXString.cpp  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Source/FXString.cpp-arc  $ 
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:49:02  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 */
//  System Header File(s)
// None 

//  User-Defined Header File(s)
//TEPEM #include "EM.h"

//  Companion Header File for This Class
#include "FXString.h"

//  Source ID Tracking Number
char *FXString::pszVCSId = "$Header:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Source/FXString.cpp-arc   2.0   Sep 03 2003 15:49:02   JohnsT  $";

//  Module Symbolic Constant(s)
// None 

// Macro Define(s)
// None 


// Enumerated Type(s)
// None

/*  
 *===========================================================================
 */
/** \fn FXString::FXString
 *
 *  This routine provides the constructor method.   It initializes the class
 *  at creation.
 *
 *  \param   None
 *
 *  \return  None
 *
 *  \par Error(s):  
 *           None
 */
/*===========================================================================
 */  
FXString::FXString()
{
   pszBuffer = NULL;
   pcCurToken = NULL;
}


/*  
 *===========================================================================
 */
/** \fn FXString::~FXString
 *
 *  This routine provides the destructor method.
 *
 *  \param   None
 *
 *  \return  None
 *
 *  \par Error(s):  
 *           None
 */
/*===========================================================================
 */  
FXString::~FXString()
{
}


/*  
 *===========================================================================
 */
/** \fn FXString::getBuffer
 *
 *  This routine returns a pointer to the character string contained in
 *  pszBuffer.
 *
 *  \param None
 *
 *  \return (char *)pszBuffer
 *
 *  \par Error(s):  
 *           None
 */
/*===========================================================================
 */ 
const char *FXString::getBuffer() const
{
   return (const char *)pszBuffer;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getFixedLength
 *
 *  This routine returns the buffer space for each fixed length string
 *  excluding the NULL character.
 *
 *  \param    None
 *
 *  \return   (int16) ui2Length
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */ 
uint16 FXString::getFixedLength() const
{
   return ui2Length;
}


/*  
 *===========================================================================
 */
/** \fn FXString::length
 *
 *  This routine returns the length of pszBuffer excluding the NULL character.
 *
 *  \param    None
 *
 *  \return   (int16)( strlen( pszBuffer ) )
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
uint16 FXString::length( void ) const
{
   return (int16)( strlen( pszBuffer ) );
}


/*  
 *===========================================================================
 */
/** \fn FXString::toUp
 *
 *  this method will make all characters in the pszBuffer string uppercase
 *
 *  \param   None
 *
 *  \return  (tStdReturn)SUCCESS
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::toUp( void )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iIndex;
   
   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iIndex      = 0;

   // loop through pszBuffer performing toupper on all char's until we reach '\0'
   while( pszBuffer[iIndex] != '\0' )
   {
      pszBuffer[iIndex] = (char)toupper( pszBuffer[iIndex] );
      iIndex++;
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::toLow
 *
 *  this method will make all characters in the pszBuffer string lowercase
 *
 *  \param    None
 *
 *  \return   (tStdReturn)SUCCESS
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::toLow( void )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iIndex;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iIndex      = 0;

   // loop through pszBuffer performing toupper on all char's until we reach '\0'
   while( pszBuffer[iIndex] != '\0' )
   {
      pszBuffer[iIndex] = (char)tolower( pszBuffer[iIndex] );
      iIndex++;
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::copy
 *
 *  This routine will copy fxStr.pszBuffer to the pszBuffer using the 
 *  overloaded method copy:char *.  It will then relog any errors which
 *  occurred in copy:char *.
 *
 *  \param    FXString fxStr   INPUT   the string to be copied
 *
 *  \return   (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */ 
tStdReturn FXString::copy( const FXString &fxStr )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iErrLineNo;
   int32      i4ErrorCode;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   srReturn   = copy( fxStr.pszBuffer );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::copy:char *" );
      //TEPEM   EM::reLogError( "FXString::copy:char *", "FXString::copy:FXString", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::copy
 *
 *  This routine will copy pszString to the pszBuffer.  It tests to
 *  make sure that there exists enough buffer space to perform the 
 *  copy.  If there is it will do a strcpy, otherwise it will do a strncpy
 *  copying in as much as possible and then put an error.
 *
 *  \param    char *pszString   INPUT   the string to be copied
 *
 *  \return   (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
tStdReturn FXString::copy( const char *pszString )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iTmpLength;
   int        iCount;
   int        iIndex;
   int        iErrLineNo;

   // mandatory initialization of all local variables
   srReturn   = SUCCESS;
   iTmpLength = 0;
   iCount     = 0;
   iIndex     = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      // NOTE: adding one to the total length allows 1 space for the NULL character
      iTmpLength = ( strlen( pszString ) ) + 1;

      iErrLineNo = __LINE__ + 1;
      if( iTmpLength <= ui2MaxLength )
      {
         strcpy( pszBuffer, pszString );
      }
      else
      {
         strncpy( pszBuffer, pszString, ui2Length );
         pszBuffer[ui2Length] = '\0';
         sprintf( szComment, "requires %d buffer spaces, the max is %d.", iTmpLength, ui2MaxLength );
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::copy:char *", szComment, iErrLineNo );
         srReturn = FAILURE;
      }
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::copy:char *", NULL, iErrLineNo );
   }

   return srReturn;
}

/*  
 *===========================================================================
 */
/** \fn FXString::copy
 *
 *  This routine will copy cCharacter to the pszBuffer using the overloaded
 *  method copy:char *.  It wil then relog any errors which occured in
 *  copy:char *.
 *
 *  \param    char cCharacter  INPUT   the character to be copied
 *  
 *  \return   (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::copy( char cCharacter )
{
   // declaration of all local variables
   tStdReturn srReturn;
   char       szTmpBuffer[2] = "\0";
   int        iErrLineNo;
   int32      i4ErrorCode;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   // place the character into a NULL terminated string
   szTmpBuffer[0] = cCharacter;
   szTmpBuffer[1] = '\0';

   srReturn   = copy( szTmpBuffer );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::copy:char *" );
      //TEPEM   EM::reLogError( "FXString::copy:char *", "FXString::copy:char", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::copyN
 *
 *  This routine will copy a specified number of characters from fxStr.pszBuffer
 *  to the pszBuffer using the overloaded copyN:char * method.  It will then
 *  relog any errors which occurred in copyN:char *.
 *
 *  \param   FXString fxStr    INPUT   the string to be copied
 *             
 *  \param   int16  iCount   INPUT   number of chars to be copied to the buffer
 *
 *  \return (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::copyN( const FXString &fxStr, int16 i2Count )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iErrLineNo;
   int32      i4ErrorCode;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   srReturn   = copyN( fxStr.pszBuffer, i2Count );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::copyN:char *" );
      //TEPEM   EM::reLogError( "FXString::copyN:char *", "FXString::copyN:FXString", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::copyN
 *
 *  This routine will copy iCount characters from pszString to the pszBuffer.
 *  It tests to make sure that there exists enough buffer space to perform the 
 *  copy.  If there is it will do a strcpy, otherwise it recalculate the count
 *  and copy as much as possible and then put an error.
 *
 *  \param    char *pszString   INPUT   the string to be copied
 *             
 *  \param    int16 i2Count     INPUT   number of chars to be copied to the buffer
 *
 *  \return   (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
tStdReturn FXString::copyN( const char *pszString, int16 i2Count )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iTmpCount;
   int        iIndex;
   int        iErrLineNo;

   // mandatory initialization of all local variables
   srReturn   = SUCCESS;
   iTmpCount  = 0;
   iIndex     = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      iErrLineNo = __LINE__ + 1;
      if( i2Count < ui2MaxLength )
      {
         strncpy( pszBuffer, pszString, i2Count );
         setAt( i2Count, '\0' );
      }
      else
      {
         strncpy( pszBuffer, pszString, ui2Length );
         pszBuffer[ui2Length] = '\0';
         sprintf( szComment, "requires %d buffer spaces, the max is %d.", i2Count, ui2MaxLength );
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::copyN:char *", szComment, iErrLineNo );
         srReturn = FAILURE;
      }
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::copyN:char *", NULL, iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::concat
 *
 *  This routine will append fxStr.pszBuffer to the end of pszBuffer using the
 *  overloaded method concat:char *.  It then relogs any errors which 
 *  occurred in concat:char *.
 *
 *  \param   FXString  fxStr   INPUT   the string to be concatenated
 *
 *  \return  (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::concat( const FXString &fxStr )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iErrLineNo;
   int32      i4ErrorCode;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   srReturn   = concat( fxStr.pszBuffer );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::concat:char *" );
      //TEPEM   EM::reLogError( "FXString::concat:char *", "FXString::concat:FXString", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::concat
 *
 *  This routine will append pszString to the end of pszBuffer.  It tests to
 *  make sure that there exists enough buffer space to perform the 
 *  concatenation.  If there is it will do a strcat, otherwise it strncat as
 *  much as possible and then put an error.
 *
 *  \param   char *pszString   INPUT   the string to be concatenated
 *
 *  \return  (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
tStdReturn FXString::concat( const char *pszString )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iTmpLength;
   int        iCount;

   // mandatory initialization of all local variables
   srReturn   = SUCCESS;
   iTmpLength = 0;
   iCount     = 0;

   if( pszString != NULL )
   {
      if( pszString != pszBuffer)
      {    
         // NOTE: adding one to the total length allows 1 space for the NULL character
         iTmpLength = ( strlen( pszBuffer ) ) + ( strlen( pszString ) ) + 1;

         if( iTmpLength <= ui2MaxLength )
         {
            strcat( pszBuffer, pszString );
         }
         else
         {
            iCount = ui2Length - ( strlen( pszBuffer ) );
            strncat( pszBuffer, pszString, iCount );
            sprintf( szComment, "You require a buffer of at least %d, the max buffer for this type is %d.", iTmpLength, ui2MaxLength );
            //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::strcat:char *", szComment, __LINE__ );
            srReturn = FAILURE;
         }
      }
      else
      {
         //TEPEM   EM::print( "FXString::concat:char * cannot copy itself." );
         srReturn = FAILURE;
      }
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::concat:char *", NULL, __LINE__ );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::concat
 *
 *  This routine will append cCharacter to the end of pszBuffer using the
 *  overloaded method concat:char *.  It will then relog any errors which
 *  occured in concat:char *.
 *
 *  \param   char cCharacter   INPUT    the character to be concatenated
 *
 *  \return  (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::concat( char cCharacter )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iErrLineNo;
   int32      i4ErrorCode;
   char       szTmpBuffer[2] = "\0";

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   // place character into a NULL terminated string
   szTmpBuffer[0] = cCharacter;
   szTmpBuffer[1] = '\0';
   
   srReturn   = concat( szTmpBuffer );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::concat:char *" );
      //TEPEM   EM::reLogError( "FXString::concat:char *", "FXString::concat:char", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::concatN
 *
 *  This routine will append a specified number of characters from
 *  fxStr.pszBuffer to the end of pszBuffer using the overloaded method
 *  concatN:char *.  It will then relog any errors which occured in
 *  concatN:char *.
 *
 *  \param   FXString fxStr   INPUT   the string to be concatenated
 *
 *  \param   int16    i2Count    INPUT   the number of characters to be concatenated
 *
 *  \return  (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::concatN( const FXString &fxStr, int16 i2Count )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iErrLineNo;
   int32      i4ErrorCode;

   // mandatory initialization of all local variables
   srReturn    = SUCCESS;
   iErrLineNo  = 0;
   i4ErrorCode = 0;

   srReturn   = concatN( fxStr.pszBuffer, i2Count );
   iErrLineNo = __LINE__ - 1;

   if( srReturn == FAILURE )
   {
      //TEPEM   EM::getLastErrorCode( &i4ErrorCode, "FXString::concatN:char *" );
      //TEPEM   EM::reLogError( "FXString::concat:char *", "FXString::concatN:FXString", iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::concatN
 *
 *  This routine will append pszString to the end of pszBuffer.  It tests to
 *  make sure that there exists enough buffer space to perform the 
 *  concatenation.  If there is it will do a strncat, otherwise it will
 *  recalculate the count then strncat as much as possible and then put an
 *  error.
 *
 *  \param   char *pszString   INPUT   the string to be concatenated
 *
 *  \param   int16 i2Count     INPUT   the number of characters to be concatenated
 *
 *  \return  (tStdReturn)SUCCESS/FAILURE
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
tStdReturn FXString::concatN( const char *pszString, int16 i2Count )
{
   // declaration of all local variables
   tStdReturn srReturn;
   int        iTmpLength;
   int        iErrLineNo;
   int        iCount;

   // mandatory initialization of all local variables
   srReturn   = SUCCESS;
   iTmpLength = 0;
   iErrLineNo = 0;
   iCount     = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      if( pszString != pszBuffer )
      {
         iTmpLength = (strlen(pszBuffer)) + i2Count + 1;
         iErrLineNo = __LINE__ + 1;
         if( iTmpLength <= ui2MaxLength )
         {
            strncat( pszBuffer, pszString, i2Count );
         }
         else
         {
            iCount = ui2Length - ( strlen( pszBuffer ) );
            strncat( pszBuffer, pszString, iCount );
            sprintf( szComment, "You require a buffer of at least %d, the max buffer for this type is %d.", i2Count, ui2MaxLength );
            //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::concatN:char *", szComment, iErrLineNo );
            srReturn = FAILURE;
         }
      }
      else
      {
         //TEPEM   EM::print( "FXString::concatN:char * cannot copy itself." );
         srReturn = FAILURE;
      }
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::concatN:char *", NULL, iErrLineNo );
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compare
 * 
 *  This routine will, on a case sensitive basis, compare pszBuffer to
 *  fxStr.pszBuffer using the overloaded method compare:char *.  It will
 *  then reLog any errors which occured in compare:char *.
 *
 *  \param   FXString &fxStr   INPUT   the string to be compared
 *
 *  \return  (int16)<0 if string1 is less than string2  <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2  <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compare( const FXString &fxStr ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   // NOTE: Error checking must be performed here as well as in compare:char *
   //       due to the fact that the compare methods do not return definite
   //       FAILUREs
   iErrLineNo = __LINE__ + 1;
   if( fxStr.pszBuffer != NULL )
   {
      // NOTE: for code maintainability the overloaded compare was used,
      //       however, if efficiency is an issue this could easily be 
      //       replaced with a strcmp maintaining the same parameters. - JAS
      i2Return = compare(fxStr.pszBuffer );
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compare:FXString", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compare
 *
 *  This routine will, on a case sensitive basis, compare pszBuffer to
 *  pszString using the strcmp method.
 *
 *  \param   char *pszString   INPUT   the string to be compared
 *
 *  \return  (int16)<0 if string1 is less than string2 <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2 <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compare( const char *pszString ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      i2Return = (int16)strcmp( pszBuffer, pszString );
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compare:char *", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compare
 *
 *  This routine will, on a case sensitive basis, compare pszBuffer to
 *  cCharacter using the overloaded method compare:char *.
 *
 *  \param   char cCharacter   INPUT   the char to be compared
 *
 *  \return  (int16)<0 if string1 is less than string2 <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2   <br>
 *
 *
 *  \par Error(s):  
 *            EFXS_NULL_CHARACTER
 */
/*===========================================================================
 */  
int16 FXString::compare( char cCharacter ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;
   char  szTmpBuffer[ 2 ] = "\0";

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( cCharacter != '\0' )
   {
      szTmpBuffer[0] = cCharacter;
      szTmpBuffer[1] = '\0';
      // NOTE: for code maintainability the overloaded compare was used,
      //       however, if efficiency is an issue this could easily be 
      //       replaced with a strcmp maintaining the same parameters. - JAS
      i2Return = compare( szTmpBuffer );
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_CHARACTER, eError, "FXString::compare:char", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compareN
 *
 *  fxStr.pszBuffer for the specified count of characters using the overloaded
 *  method comparen:char *.
 *
 *  \param   FXString &fxStr   INPUT   the string to be compared
 *             
 *  \param   int16  i2Count  INPUT   the number of chars to be counted
 *
 *  \return  (int16)<0 if string1 is less than string2  <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2  <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareN( const FXString &fxStr, int16 i2Count ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( fxStr.pszBuffer != NULL )
   {
      iErrLineNo = __LINE__ + 1;
      if( i2Count < ui2MaxLength )
      {
         // NOTE: for code maintainability the overloaded compare was used,
         //       however, if efficiency is an issue this could easily be 
         //       replaced with a strcmp maintaining the same parameters. - JAS
         i2Return = compareN( fxStr.pszBuffer, i2Count );
      }
      else
      {
         i2Return = -1;
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::compareN:char *", szComment, iErrLineNo );
      }
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareN:FXString", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compareN
 *
 *  This routine will, on a case sensitive basis, compare pszBuffer to
 *  pszString for the specified count of characters using strncmp.
 *
 *  \param   char *pszString   INPUT   the string to be compared
 *             
 *  \param   int16 i2Count     INPUT   the number of chars to be counted
 *
 *  \return  (int16)<0 if string1 is less than string2 <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2  <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareN( const char *pszString, int16 i2Count ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      iErrLineNo = __LINE__ + 1;
      if( i2Count < ui2MaxLength )
      {
         // NOTE: for code maintainability the overloaded compare was used,
         //       however, if efficiency is an issue this could easily be 
         //       replaced with a strcmp maintaining the same parameters. - JAS
         i2Return = (int16)strncmp( pszBuffer, pszString, i2Count );
      }
      else
      {
         i2Return = -1;
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::compareN:char *", szComment, iErrLineNo );
      }
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareN:char *", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compareI
 *
 *  This routine will, on a non-case sensitive basis, compare pszBuffer to
 *  fxStr.pszBuffer using the overloaded method compareI:char *.
 *
 *  \param   FXString &fxStr       INPUT   the string to be compared
 *
 *  \return  (int16)<0 if string1 is less than string2  <br>
 *                   0 if string1 is identical to string2  <br>
 *                  >0 string1 greater than string2 <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareI( const FXString &fxStr ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( fxStr.pszBuffer != NULL )
   {
      // NOTE: for code maintainability the overloaded compare was used,
      //       however, if efficiency is an issue this could easily be 
      //       replaced with a strcmp maintaining the same parameters. - JAS
      i2Return = compareI(fxStr.pszBuffer );
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareI:FXString", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compareI
 *
 *  This routine will, on a non-case sensitive basis, compare pszBuffer to
 *  pszString using stricmp.
 *
 *  \param    char *pszString    INPUT   the string to be compared
 *
 *  \return   (int16)<0 if string1 is less than string2 <br>
 *                    0 if string1 is identical to string2  <br>
 *                   >0 string1 greater than string2  <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareI( const char *pszString ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;
   char *copy1;
   char  myString[257];///TEP
   char  myBuffer[257];///TEP
   int iIndex = 0;     ///TEP

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {


//TEPFIX      i2Return = (int16)stricmp( pszBuffer, pszString );//TEPFIX

///////////////////////
///*TEPFIX
      // loop through pszBuffer performing tolower on all char's until we reach '\0'
      while( pszBuffer[iIndex] != '\0' )
      {
         myBuffer[iIndex] = (char)tolower( pszBuffer[iIndex] );
         iIndex++;
      }

      myBuffer[iIndex] = pszBuffer[iIndex];  //this should append a \0 to end

      iIndex = 0;

      while( pszString[iIndex] != '\0' )
      {
         myString[iIndex] = (char)tolower( pszString[iIndex] );
         iIndex++;
      }

      myString[iIndex] = pszString[iIndex];  //this should append a \0 to end


      i2Return = strcmp( myBuffer, myString);

//*/
////////////////////////////////

   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareI:char *", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn  FXString::compareI
 *
 *  This routine will, on a non-case sensitive basis, compare pszBuffer to
 *  cCharacter using the overloaded method compareI:char *.
 *
 *  \param   char cCharacter   INPUT   the char to be compared
 *
 *  \return  (int16)<0 if string1 is less than string2 <br>
 *                   0 if string1 is identical to string2 <br>
 *                  >0 string1 greater than string2 <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_CHARACTER
 */
/*===========================================================================
 */  
int16 FXString::compareI( char cCharacter ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;
   char  szTmpBuffer[ 2 ] = "\0";

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( cCharacter != '\0' )
   {
      szTmpBuffer[0] = cCharacter;
      szTmpBuffer[1] = '\0';
      // NOTE: for code maintainability the overloaded compare was used,
      //       however, if efficiency is an issue this could easily be 
      //       replaced with a strcmp maintaining the same parameters. - JAS
      i2Return = compareI( szTmpBuffer );
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_CHARACTER, eError, "FXString::compareI:char", NULL, iErrLineNo );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::compareNI
 *
 *  This routine will, on a non-case sensitive basis, compare pszBuffer to
 *  fxStr.pszBuffer for the specified count of characters using the overloaded
 *  method compareNI:char *.
 *
 *  \param  FXString &fxStr    INPUT   the string to be compared
 *
 *  \param  int16 i2Count      INPUT   the number of chars to be counted
 *
 *  \return (int16)<0 if string1 is less than string2 <br>
 *                  0 if string1 is identical to string2 <br>
 *                 >0 string1 greater than string2  <br>
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareNI( const FXString &fxStr, int16 i2Count ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( fxStr.pszBuffer != NULL )
   {
      iErrLineNo = __LINE__ + 1;
      if( i2Count < ui2MaxLength )
      {
         // NOTE: for code maintainability the overloaded compare was used,
         //       however, if efficiency is an issue this could easily be 
         //       replaced with a strcmp maintaining the same parameters. - JAS
         i2Return = compareNI( fxStr.pszBuffer, i2Count );
      }
      else
      {
         i2Return = -1;
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::compareNI:FXString", szComment, iErrLineNo );
      }
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareNI:FXString", NULL, iErrLineNo );
   }

   return i2Return;
}

/*  
 *===========================================================================
 */
/** \fn FXString::compareNI
 *
 *  This routine will, on a non-case sensitive basis, compare pszBuffer to
 *  pszString for the specified count of characters using strnicmp.
 *
 *  \param   char *pszString   INPUT   the string to be compared
 *
 *  \param   int16 i2Count     INPUT   the number of chars to be counted
 * 
 *  \return  (int16)<0 if string1 is less than string2 <br>
 *                   0 if string1 is identical to string2 <br>
 *                  >0 string1 greater than string2 <br>
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int16 FXString::compareNI( const char *pszString, int16 i2Count ) const
{
   // declaration of all local variables
   int16 i2Return;
   int   iErrLineNo;

   char  myString[257];///TEP
   char  myBuffer[257];///TEP
   int   iIndex = 0;   ///TEP


   // mandatory initialization of all local variables
   i2Return   = 0;
   iErrLineNo = 0;

   if( pszString != NULL )
   {
      iErrLineNo = __LINE__ + 1;
      if( i2Count < ui2MaxLength )
      {
         // NOTE: for code maintainability the overloaded compare was used,
         //       however, if efficiency is an issue this could easily be 
         //       replaced with a strcmp maintaining the same parameters. - JAS

//TEPFIX         i2Return = (int16)strnicmp( pszBuffer, pszString, i2Count );//TEPFIX

///*TEPFIX
         // loop through pszBuffer performing tolower on all char's until we reach '\0'
         while( pszBuffer[iIndex] != '\0' )
         {
            myBuffer[iIndex] = (char)tolower( pszBuffer[iIndex] );
            iIndex++;
         }

         myBuffer[iIndex] = pszBuffer[iIndex];  //this should append a \0 to end

         iIndex = 0;

         while( pszString[iIndex] != '\0' )
         {
            myString[iIndex] = (char)tolower( pszString[iIndex] );
            iIndex++;
         }

         myString[iIndex] = pszString[iIndex];  //this should append a \0 to end


         i2Return = (int16)strncmp( pszBuffer, pszString, i2Count );
//*/
//////////////////////////////////


      }
      else
      {
         i2Return = -1;
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::compareNI:char *", szComment, iErrLineNo );
      }
   }
   else
   {
      i2Return = 1;
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::compareNI:char *", NULL, 0 );
   }

   return i2Return;
}


/*  
 *===========================================================================
 */
/** \fn FXString::inStr
 *
 *  This routine will search pszBuffer for the first occurance of 
 *  fxStr.pszBuffer using the overloaded method inStr( const char *).
 *
 *  \param  fxStr    the FXString& that holds the string to be found.
 *  \param  i2Start  the uint16 that tells the index of where to start looking
 *                   for the substring.  This parameter defaults to 0, the
 *                   beginning of the string.
 *       
 *  \return  an int representing the index of where the substring was found;
 *           -1 if the substring was not found.
 *
 *  \par Error(s):  
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int FXString::inStr( const FXString &fxStr, uint16 i2Start) const
{
   // mandatory initialization of all local variables
   int iIndex = -1;
   int   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( fxStr.pszBuffer != NULL )
   {
      iIndex = inStr( fxStr.pszBuffer, i2Start );
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::substring:FXString", NULL, 0 );
   }

   return iIndex;
}


/*  
 *===========================================================================
 */
/** \fn FXString::inStr
 *
 *  This routine will search pszBuffer for the first occurance of pszString
 *  using strstr.
 *
 *  \param  pszString  the const char* of the string to be found.
 *  \param  i2Start    the uint16 that tells the index of where to start looking
 *                     for the substring.  This parameter defaults to 0, the
 *                     beginning of the string.
 *       
 *  \return  an int representing the index of where the substring was found;
 *           -1 if the substring was not found.
 *
 *  \par Error(s):  
 *            EFXS_EXCEEDS_MAX_LENGTH
 *            EFXS_NULL_POINTER
 */
/*===========================================================================
 */  
int FXString::inStr( const char *pszString, uint16 i2Start) const
{
   // mandatory initialization of all local variables
   int iIndex = -1;
   char *pcResult = NULL;
   int16 iTmpLength = 0;
   int   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( pszString != NULL )
   {
      iTmpLength = (int16)strlen(pszString);
      iErrLineNo = __LINE__ + 1;
      if( iTmpLength < ui2MaxLength )
      {
         pcResult = strstr( pszBuffer+i2Start, pszString );

         if(pcResult != NULL)
         {
            iIndex = pcResult - pszBuffer;
         }
      }
      else
      {
         //TEPEM   EM::putError( EFXS_EXCEEDS_MAX_LENGTH, eError, "FXString::substring:char *", NULL, iErrLineNo );
      }
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_POINTER, eError, "FXString::substring:char *", NULL, iErrLineNo );
   }

   return iIndex;
}


/*  
 *===========================================================================
 */
/** \fn FXString::inStr
 *
 *  This routine will search pszBuffer for the first occurance of 
 *  cCharacter using the overloaded method inStr( const char *).
 *
 *  \param  cChar    the char to be found.
 *  \param  i2Start  the uint16 that tells the index of where to start looking
 *                   for the substring.  This parameter defaults to 0, the
 *                   beginning of the string.
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
int FXString::inStr( char cChar, uint16 i2Start) const
{
   // mandatory initialization of all local variables
   int  iIndex = -1;
   char  szTmpBuffer[2] = "\0";
   int   iErrLineNo = 0;

   iErrLineNo = __LINE__ + 1;
   if( cChar != '\0' )
   {
      szTmpBuffer[0] = cChar;
      szTmpBuffer[1] = '\0';
      iIndex = inStr( szTmpBuffer, i2Start );
   }
   else
   {
      //TEPEM   EM::putError( EFXS_NULL_CHARACTER, eError, "FXString::substring:char", NULL, iErrLineNo );
   }

   return iIndex;
}


/*  
 *===========================================================================
 */
/** \fn FXString::strTok
 *
 *  This method gets the next token in a string based on a delimiter.  To be
 *  certain of the internal tokenizer placement.  A call to resetTok should
 *  be called before the first call to strTok, or after a change to the 
 *  FXString.<br>
 *  When no more tokens are left, an empty string ( pszThisToken[0] = '\0' )
 *  is returned.
 *
 *  \param    char *pszThisToken  UPDATE  the delimited token
 *             
 *  \param    const char *pszDelim  IN    the delimiter
 *
 *  \return   None
 *
 *  \par Error(s):  
 *            None
 */
/*===========================================================================
 */  
tStdReturn FXString::strTok( char *pszThisToken, const char *pszDelim )
{
   // Initialize all local variables
   char *pcNextToken = NULL;
   int  i2TempLength = 0;
   tStdReturn srRetVal = SUCCESS;
   
   // Initialize output variable to null
   strcpy( pszThisToken,"\0" );
   
   if( strcmp( pszBuffer, "" ) != STRINGS_IDENTICAL )
   {
      //if the token pointer is null, set it to the beginning
      if( pcCurToken == NULL )
         pcCurToken = pszBuffer;

      //find the next token
      pcNextToken = strpbrk( pcCurToken, pszDelim );
   
      //calc the length of the token
      if( pcNextToken != NULL )
      {
         i2TempLength = ( pcNextToken - pcCurToken );
         strncat( pszThisToken, pcCurToken, i2TempLength );    
         pcCurToken = pcNextToken + 1;
      }
      else
      {
         i2TempLength = strlen( pcCurToken );
         strncat( pszThisToken, pcCurToken, i2TempLength );    
         pcCurToken += i2TempLength;
      }
   }
   else
   {
      //TODO add error code for getting passed a blank message (pszBuffer =="")
      srRetVal = FAILURE;
   }
   
   return( srRetVal );
}


/*  
 *===========================================================================
 */
/** \fn FXString::resetTok
 *
 *  This method resets the internal token pointer used by strTok, and thereby
 *  returning the tokenizer back to the beginning.
 *
 *  \return  None
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */  
void FXString::resetTok( void )
{
   pcCurToken = NULL;
}


/*  
 *===========================================================================
 */
/** \fn FXString::left
 *
 *  This method takes the substring of itself starting at position 0 and taking
 *  the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::left( uint16 ui2LeftLength )
{
   // Initialize all local variables
   tStdReturn srReturn;

   srReturn = mid( 0, ui2LeftLength );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::left
 *
 *  This method takes the substring of the given const char * starting at
 *  position 0 and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  pszStr         the const char * to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::left( uint16 ui2LeftLength, const char *pszStr )
{
   // Initialize all local variables
   tStdReturn srReturn;

   srReturn = mid( 0, ui2LeftLength, pszStr );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::left
 *
 *  This method takes the substring of the given FXString starting at
 *  position 0 and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  fxStr          the FXString to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::left( uint16 ui2LeftLength, const FXString &fxStr )
{
   // Initialize all local variables
   tStdReturn srReturn;

   srReturn = mid( 0, ui2LeftLength, fxStr );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::right
 *
 *  This method takes the substring of itself starting at the end of the 
 *  string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::right( uint16 ui2RightLength )
{
   // Initialize all local variables
   tStdReturn srReturn;

   srReturn = mid( (uint16)(length()-ui2RightLength), ui2RightLength );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::right
 *
 *  This method takes the substring of the given const char * starting at the
 *  end of the string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  pszStr         the const char * to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::right( uint16 ui2RightLength, const char *pszStr )
{
   // Initialize all local variables
   tStdReturn srReturn;

   srReturn = mid( (uint16)(strlen(pszStr)-ui2RightLength), ui2RightLength, pszStr );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::right
 *
 *  This method takes the substring of the given FXString starting at the
 *  end of the string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  fxStr          the FXString to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::right( uint16 ui2RightLength, const FXString &fxStr )
{
   // Initialize all local variables
   tStdReturn srReturn = SUCCESS;

   srReturn = mid( (uint16)(fxStr.length()-ui2RightLength), ui2RightLength, fxStr );
   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::mid
 *
 *  This method takes the substring of itself starting at the
 *  specified index of the string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::mid( uint16 ui2Start, uint16 ui2MidLength )
{
   // Initialize all local variables
   tStdReturn srReturn = SUCCESS;

   srReturn = mid( ui2Start, ui2MidLength, pszBuffer );

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::mid
 *
 *  This method takes the substring of itself starting at the
 *  specified index of the string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  pszStr         the const char * to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::mid( uint16 ui2Start, uint16 ui2MidLength, const char *pszStr )
{
   // Initialize all local variables
   uint16 ui2Count = 0;
   int iIndex = 0;
   tStdReturn srReturn = SUCCESS;

   ui2Count = (int16) strlen( pszStr );

   if (ui2Start > ui2Count )
   {
      pszBuffer[0] = '\0';
   }
   else if ((ui2MidLength > ui2Count) && (ui2Start == 0))
   {
      // do nothing
   }
   else
   {
      for (iIndex=0; iIndex<ui2MidLength; iIndex++)
      { 
         pszBuffer[iIndex] = pszStr[iIndex+ui2Start];
      }
      pszBuffer[iIndex] = '\0';
   }

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::mid
 *
 *  This method takes the substring of itself starting at the
 *  specified index of the string and taking the length specified.
 *
 *  \param  ui2LeftLength  the length of the substring to create.
 *  \param  fxStr          the FXString to take the substring from.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::mid( uint16 ui2Start, uint16 ui2MidLength, const FXString &fxStr )
{
   // Initialize all local variables
   tStdReturn srReturn = SUCCESS;

   srReturn = mid( ui2Start, ui2MidLength, fxStr.getBuffer() );

   return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getBoolean
 *
 *  This method converts the contents of the FXString into a boolean.
 *
 *  \param  pbValue  a pointer to the boolean that will hold the conversion.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::getBoolean( bool *pbValue ) const
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;

   if( compareI("true") == STRINGS_IDENTICAL )
      *pbValue = true;
   else
   if( compareI("false") == STRINGS_IDENTICAL )
      *pbValue = false;
   else
      srStatus = FAILURE;

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getDouble
 *
 *  This method converts the contents of the FXString into a double.
 *
 *  \param  pdValue  a pointer to the doulbe that will hold the conversion.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::getDouble( double *pdValue ) const
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iResult = 0;
   double dRes = 0.0;

   iResult = sscanf( getBuffer(), "%lf", &dRes );

   if( iResult == EOF )
   {
      srStatus = FAILURE;
      // handle EOF failure
   }
   else if( iResult == 0 )
   {
      srStatus = FAILURE;
      // handle sscanf failure
   }
   else
   {
    *pdValue = dRes;
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getHex
 *
 *  This method converts the contents of the FXString into an integer.  It
 *  assumes the string is in hex.
 *
 *  \param  piValue  a pointer to the integer that will hold the hex 
 *                   conversion.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::getHex( int *piValue ) const
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iRes = 0;
   int iResult = 0;

   iResult = sscanf( getBuffer(), "%x", &iRes );

   if( iResult == EOF )
   {
     srStatus = FAILURE;
     // handle EOF failure
   }
   else if( iResult == 0 )
   {
     srStatus = FAILURE;
     // handle sscanf failure
   }
   else
   {
     *piValue = iRes;
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getInt
 *
 *  This method converts the contents of the FXString into a integer.
 *
 *  \param  piValue  a pointer to the int that will hold the conversion.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::getInt( int *piValue ) const
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iRes = 0;
   int iResult = 0;


   iResult = sscanf( getBuffer(), "%i", &iRes );

   if( iResult == EOF )
   {
     srStatus = FAILURE;
     // handle EOF failure
   }
   else if( iResult == 0 )
   {
     srStatus = FAILURE;
     // handle sscanf failure
   }
   else
   {
     *piValue = iRes;
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::getLong
 *
 *  This method converts the contents of the FXString into a long integer.
 *
 *  \param  pliValue  a pointer to the int that will hold the conversion.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::getLong( long int *pliValue ) const
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   long int liRes = 0;
   int iResult = 0;

   iResult = sscanf( getBuffer(), "%li", &liRes );

   if( iResult == EOF )
   {
     srStatus = FAILURE;
     // handle EOF failure
   }
   else if( iResult == 0 )
   {
     srStatus = FAILURE;
     // handle sscanf failure
   }
   else
   {
     *pliValue = liRes;
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setBoolean
 *
 *  This method sets the FXString to a conversion of the given boolean.
 *
 *  \param  bValue  the boolean that will be converted to a string.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::setBoolean( bool bValue )
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;

   if( bValue == true )
      copy( "true" );
   else
   if( bValue == false )
      copy( "false" );
   else
      srStatus = FAILURE;

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setDouble
 *
 *  This method sets the FXString to a conversion of the given double.
 *
 *  \param  dValue    the double that will be converted to a string.
 *  \param  pszFormat a pointer to the const char * that represents the format.<br>
 *                    Example: 8.3 - means total width of 8, decimal precision
 *                    of 3.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */ 
tStdReturn FXString::setDouble( double dValue, char *pszFormat )
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iResult = 0;
   char pszFrm[11];
        pszFrm[0] = NULL;

   if( strlen( pszFormat ) > 7 )
   {
      srStatus = FAILURE;
   }
   else
   {
      pszFrm[0] = '%';
      strcpy( &pszFrm[1], pszFormat );
      strcpy( &pszFrm[1+strlen(pszFormat)], "lf" );

      iResult = sprintf( pszBuffer, pszFrm, dValue );

      if( iResult < 0 )
      {
         srStatus = FAILURE;
         // handle sprintf failure
      }
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setHex
 *
 *  This method sets the FXString to a conversion of the given hex.
 *
 *  \param  iValue    the int (in hex) that will be converted to a string.
 *  \param  pszFormat a pointer to the const char * that represents the format.<br>
 *                    Example: 8 - means total width of 8.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
tStdReturn FXString::setHex( int iValue, char *pszFormat )
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iResult = 0;
   char pszFrm[10];
        pszFrm[0] = NULL;

   if( strlen( pszFormat ) > 7 )
   {
      srStatus = FAILURE;
   }
   else
   {
      pszFrm[0] = '%';
      strcpy( &pszFrm[1], pszFormat );
      strcpy( &pszFrm[1+strlen(pszFormat)], "x" );

      iResult = sprintf( pszBuffer, pszFrm, iValue );

      if( iResult < 0 )
      {
         srStatus = FAILURE;
         // handle sprintf failure
      }
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setInt
 *
 *  This method sets the FXString to a conversion of the given int.
 *
 *  \param  iValue    the int that will be converted to a string.
 *  \param  pszFormat a pointer to the const char * that represents the format.<br>
 *                    Example: 8 - means total width of 8.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
tStdReturn FXString::setInt( int iValue, char *pszFormat )
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iResult = 0;
   char pszFrm[10];
        pszFrm[0] = NULL;

   if( strlen( pszFormat ) > 7 )
   {
      srStatus = FAILURE;
   }
   else
   {
      pszFrm[0] = '%';
      strcpy( &pszFrm[1], pszFormat );
      strcpy( &pszFrm[1+strlen(pszFormat)], "i" );

      iResult = sprintf( pszBuffer, pszFrm, iValue );

      if( iResult < 0 )
      {
         srStatus = FAILURE;
         // handle sprintf failure
      }
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setLong
 *
 *  This method sets the FXString to a conversion of the given long int.
 *
 *  \param  liValue   the long int that will be converted to a string.
 *  \param  pszFormat a pointer to the const char * that represents the format.<br>
 *                    Example: 8 - means total width of 8.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
tStdReturn FXString::setLong( long int liValue, char *pszFormat )
{
   // Initialize all local variables
   tStdReturn srStatus = SUCCESS;
   int iResult = 0;
   char pszFrm[10];
        pszFrm[0] = NULL;

   if( strlen( pszFormat ) > 7 )
   {
      srStatus = FAILURE;
   }
   else
   {
      pszFrm[0] = '%';
      strcpy( &pszFrm[1], pszFormat );
      strcpy( &pszFrm[1+strlen(pszFormat)], "li" );

      iResult = sprintf( pszBuffer, pszFrm, liValue );

      if( iResult < 0 )
      {
         srStatus = FAILURE;
         // handle sprintf failure
      }
   }

   return srStatus;
}


/*  
 *===========================================================================
 */
/** \fn FXString::reverse
 *
 *  This method reverses the order of the characters in the current FXString.
 *
 *  \return  None
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
void FXString::reverse()
{
    int16 ui2Front = 0; // index to front character
    int16 ui2Rear = 0;  // index to rear character
    char cChar;    // temporary store
    
    ui2Rear = (int16)(length() - 1);

    while( ui2Front < ui2Rear)
    {
       cChar = pszBuffer[ui2Front];              // store front character
       pszBuffer[ui2Front] = pszBuffer[ui2Rear]; // swap rear character to front
       pszBuffer[ui2Rear]  = cChar;              // store front character in rear

       ui2Front++;
       ui2Rear--;
    }
}


/*  
 *===========================================================================
 */
/** \fn FXString::getAt
 *
 *  This method returns the char from the requested index.
 *
 *  \param  ui2Location  the index to get the char from.
 *
 *  \return  a char representing the char at the requested index.
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
char FXString::getAt( uint16 ui2Location ) const
{
   char cCharAtLocation = NULL;

   if (ui2Location < length()) 
   {
      cCharAtLocation = pszBuffer[ui2Location];
   }
   return cCharAtLocation;
}


/*  
 *===========================================================================
 */
/** \fn FXString::setAt
 *
 *  This method sets the FXString to a conversion of the given int.
 *
 *  \param  ui2Location  the index of the char to set.
 *  \param  cCharacter   the char used to set the char at the given index.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
tStdReturn FXString::setAt( uint16 ui2Location, char cCharacter )
{
    tStdReturn srReturn;
    
    srReturn = FAILURE;
    if (ui2Location < length()) 
    {
       pszBuffer[ui2Location] = cCharacter;
       srReturn = SUCCESS;
    } 
    else 
    {
       //TEPEM   EM::print("Error in FXString::setAt - need an error code!");
    }
    
    return srReturn;
}


/*  
 *===========================================================================
 */
/** \fn FXString::operator=
 *
 *  This method sets this FXString equal to the given FXString.
 *
 *  \param  ui2Location  the index of the char to set.
 *  \param  cCharacter   the char used to set the char at the given index.
 *
 *  \return  a reference to this FXString
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
FXString& FXString::operator=( const FXString &fxString)
{
   copy(fxString.getBuffer());
   return *this;
}


/*  
 *===========================================================================
 */
/** \fn FXString::atoi
 *
 *  This method returns the integer equivelant of this FXString.
 *
 *  \return  an int representing the integer equivelant of this FXString.
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
int32 FXString::atoi() const
{
   uint16 ui2Loc; // character location in string
   bool bIsNeg; // number is negative flag
   int32 i4Number; // integer being constructed
  
   // discard any leading blanks
   for(ui2Loc=0; pszBuffer[ui2Loc]==' '; ui2Loc++);

   // determine sign of number
   bIsNeg = pszBuffer[ui2Loc] == '-' ? TRUE : FALSE;

   // discard leading + or -   
   if (pszBuffer[ui2Loc] == '+' || pszBuffer[ui2Loc] == '-')
   {
      ui2Loc++;
   }

   // for each char that is a digit; scale, convert, and add
   i4Number=0;
   while (isdigit(pszBuffer[ui2Loc]))
   {
      i4Number = 10 * i4Number;
      i4Number = (pszBuffer[ui2Loc] - '0') + i4Number;
      ui2Loc++;
   }

   // set the sign
   if (bIsNeg)
   {
      i4Number = -i4Number;
   }

   return i4Number;
}


/*  
 *===========================================================================
 */
/** \fn FXString::itoa
 *
 *  This method converts the given int to a string and sets this FXString
 *  with it.
 *
 *  \param  i4IntegerToConvert  the integer to convert to a string.
 *
 *  \return  a tStdReturn
 *
 *  \par Error(s):  None
 */
/*===========================================================================
 */
tStdReturn FXString::itoa( int32 i4IntegerToConvert )
{
    bool  bIsNeg;
    char* pszTemp;
    tStdReturn srReturn;
    
    srReturn = SUCCESS;
    
    // set temporary pointer to point to first char location
    pszTemp = &pszBuffer[0];
    
    // check for negative number to convert
    bIsNeg = false;
    if (i4IntegerToConvert < 0) 
    {
    	 bIsNeg = true;
    	 i4IntegerToConvert = -i4IntegerToConvert;
    }
    
    // convert integer to ascii (in reverse order)
    do 
    {
       *pszTemp++ = (char)(i4IntegerToConvert%10 + '0');
    } while ((i4IntegerToConvert /= 10) > 0);
    
    // append '-' sign if appropriate
    if (bIsNeg) 
    {
    	*pszTemp++ = '-';  
    }
    
    // set null terminator
    *pszTemp = '\0';
    
    // reverse order
    reverse();
    
    return srReturn;
}

/*  
 *===========================================================================
 */
/** \fn FXString::clearBuffer
 *
 *  This routine will clear the buffer space for further use.
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
void FXString::clearBuffer()
{
   pszBuffer[0] = NULL;
}


/*===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/Projects/Libraries/UtilToolBox/Source/FXString.cpp-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:49:02   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:42:08   JohnsT
 * Initial revision.
 * 
 *    Rev 1.2   Mar 28 2003 16:08:02   ParsoT
 * Integrity safer.  Todd last week.
 * 
 *    Rev 1.1   Feb 21 2003 13:35:24   ParsoT
 * Updated / merged from FDS
 * 
 *    Rev 1.5   Nov 12 2002 13:19:08   McCluR
 * Added getLong and setLong conversions.  The ConfigReader classes needed them.
 * 
 *    Rev 1.4   Nov 07 2002 15:45:40   McCluR
 * fixed the default params in the conversions methods.
 * 
 *    Rev 1.3   Nov 06 2002 12:28:14   McCluR
 * Added conversion methods.
 * Fixed bugs found in reverse(), concat, copyN.
 * Fixed concat and copyN to not copy self.
 * Updated Doxygenation.
 * Resolution for 113: Add Coversion Methods to FXString
 * Resolution for 128: The FXString classes need these updates
 * Resolution for 129: FXString needs rework
 * 
 *    Rev 1.2   Nov 05 2002 11:45:54   McCluR
 * Added additional left, mid and right methods.
 * Fixed inStr to return an index instead of a pointer.
 * Removed clean() method.  Made the clearBuffer method pulbic.  should use that now.
 * Removed the base copy constructor.  Couldn't be called anyway.
 * 
 *    Rev 1.1   Oct 08 2002 08:41:56   KimmeB
 * Replace file and module headers with the Doxygen version.
 * 
 *    Rev 1.0   Jul 24 2002 14:49:10   GeisD
 * Initial Revision
 * 
 *===========================================================================


 *****  END of MODULE  *****

 */
