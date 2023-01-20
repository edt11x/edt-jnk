/*
 *===========================================================================
 *
 *  HEADER FILE:  StdMacros.h
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
 *  $Workfile:   StdMacros.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdMacros.h-arc  $
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
 *  This is one of the 'standard' files automatically included by the
 *  StdIncl.h 'standard' header file for the SIDE.
 *
 *  This header specifies the 'standard' macros associated with the SIDE.
 *
 *===========================================================================
 */

//  Protect against multiple includes
#ifndef __STDMACROSSD_H__
#define __STDMACROSSD_H__


//  MACROS

#define SQUARE( X )        ( X * X )                  // Find the Square of a value

#define DABS( X )          ( ( X < 0.0 ) ? ( -X ) : ( X ) )   //  Find Absolute value of a  real value

#define ABS( X )           ( ( X < 0   ) ? ( -X ) : ( X ) )   //  Find Absolute value of an integer value

#define LIMIT( Y, T, B )   ( ( Y > T ) ? ( T ) : ( ( Y < B ) ? B : Y ) )

#define MAXIMUM( X, Y )    ( ( X > Y ) ? ( X )  : ( Y ) )   //  Find Max of 2 values

#define MINIMUM( X, Y )    ( ( X < Y ) ? ( X )  : ( Y ) )   //  Find Min of 2 values

#define PERCENT( P )       ( (dreal)( P * 0.01 ) )

#define ROUND10( D )       ( (WORD)( (dreal)D + (dreal)0.5 ) )

#define ROUND( number, digits )   ( number >= 0.0 ) ? \
        ( (double)( (int)( ( number * pow( 10.0, (double)digits) ) + 0.5 ) / pow( 10.0, (double)digits ))) : \
        ( (double)( (int)( ( number * pow( 10.0, (double)digits) ) - 0.5 ) / pow( 10.0, (double)digits )))


#define ibCONVERT( x )     ( ( x == 0    ) ? ( false ) : ( true  ) )
/*
#define BTOGGLE( X )       ( ( X == TRUE ) ? ( FALSE ) : ( TRUE  ) )

#define bTOGGLE( X )       ( ( X == true ) ? ( false ) : ( true  ) )

#define BbCONVERT( X )     ( ( X == true ) ? ( true  ) : ( false ) )

#define bBCONVERT( X )     ( ( X == true ) ? ( true  ) : ( false ) )

#define BSET( X, Y )       ( ( X == Y    ) ? ( true  ) : ( false ) )

#define bSET( X, Y )       ( ( X == Y    ) ? ( true  ) : ( false ) )

*/

#endif   // __STDMACROS_H__

 
/*===========================================================================
 *
 *  Header Revision History
 *
 *  Rev     Date     Designer         Description of Change
 *  ------- -------- ---------------- ---------------------------------------
 *
 *   1.0    05/16/01 Tom Zawodny      Initial Release/Source Code Cleanup Pass
 *                   Bob Horky
 *===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdMacros.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:35:00   JohnsT
 * Initial revision.
 * 
 *    Rev 1.1   Dec 12 2002 10:18:40   ShellM
 * updated for kernel system integration
 * 
 *    Rev 1.1   Dec 20 2001 16:50:28   RadloK
 * Post PVCS Project Reconstruction
 * 
 *    Rev 1.0   Jul 05 2001 12:03:26   BrainL
 * Initial revision.
 *
 *===========================================================================
 

 *****  END of HEADER  *****

 */
