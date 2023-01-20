/*
 *===========================================================================
 *
 *  HEADER FILE:  StdMathConstants.h
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
 *  $Workfile:   StdMathConstants.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdMathConstants.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:50:04  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 *
 *  Overview: Standard header file that is included with StdIncl.h.
 *            This header contains Conversion Constants that support
 *            the K class.
 *             
 *
 *===========================================================================
 */

#ifndef __STDMATHCONSTANTS_H__
#define __STDMATHCONSTANTS_H__


#include "k.h"


//  ***  Conversion Constants  ***

//  Pi Constants
#define PI                    K::GPI()                      //  PI
#define TWO_PI                K::GTWO_PI()                  //  PI * 2
#define PID2                  K::GPID2()                    //  PI / 2
#define PID4                  K::GPID4()                    //  PI / 4
#define PID180                K::GPID180()                  //  PI / 180
#define IPID180               K::GIPID180()                 //  180 / PI
#define DEG_2_RAD             K::GDEG_2_RAD()               //  Degrees per Radian
#define RAD_2_DEG             K::GRAD_2_DEG()               //  Radians per Degree
#define ANGLE360              K::GANGLE360()                //  360 Degrees
#define ANGLE180              K::GANGLE180()                //  180 Degrees

//  Gravity Constant
#define G                     K::GG()                       //  Gravity ( Feet per Second^2 ) - Goodrich Standard

//  ***  Conversions involving Units of Feet  ***
#define FEET_2_INCHES         K::GFEET_2_INCHES()           //  Feet per Inch
#define INCHES_2_FEET         K::GINCHES_2_FEET()           //  Inches per Foot
#define FEET_2_METERS         K::GFEET_2_METERS()           //  Feet per Meter
#define METERS_2_FEET         K::GMETERS_2_FEET()           //  Meters per Foot
#define FEET_2_NM             K::GFEET_2_NM()               //  Nautical Miles per Foot
#define NM_2_FEET             K::GNM_2_FEET()               //  Feet per Nautical Mile
#define FEET_2_SM             K::GFEET_2_SM()               //  Statute Miles per Foot
#define SM_2_FEET             K::GSM_2_FEET()               //  Feet per Statute Mile
#define FEET_2_KM             K::GFEET_2_KM()               //  Kilometers per Foot 
#define KM_2_FEET             K::GKM_2_FEET()               //  Feet per Kilometer

//  ***  Conversions involving Units of Latitude / Longitude  ***
#define LATDEG_2_METERS       K::GLATDEG_2_METERS()         //  Meters Per Degree of Latitude
#define LATSEC_2_METERS       K::GLATSEC_2_METERS()         //  Meters Per Second of Latitude
#define LATDEG_2_FEET         K::GLATDEG_2_FEET()           //  Feet Per Degree of Latitude
#define LATDEG_2_NM           K::GLATDEG_2_NM()             //  Nautical Miles per Degree
#define DEG_2_ARCSEC          K::GDEG_2_ARCSEC()            //  Arcsec per Degree

//  ***  Conversions involving Units of Mileage  ***
#define SM_2_NM               K::GSM_2_NM()                 //  Nautical Miles per Statute Mile
#define NM_2_SM               K::GNM_2_SM()                 //  Statute Miles per Nautical Mile
#define SM_2_KM               K::GSM_2_KM()                 //  Statute Miles to Kilometers Conversion Factor
#define KM_2_SM               K::GKM_2_SM()                 //  Kilometers to Statute Miles Conversion Factor
#define NM_2_KM               K::GNM_2_KM()                 //  Nautical Miles to Kilometers Conversion Factor
#define KM_2_NM               K::GKM_2_NM()                 //  Kilometers to Nautical Miles Conversion Factor
#define NM_2_METERS           K::GNM_2_METERS()             //  Meters per Nautical Mile

//  ***  Conversions involving Units of Rates  ***
#define KTS_2_FPS             K::GKTS_2_FPS()               //  Knots to Feet per Second
#define FPS_2_KTS             K::GFPS_2_KTS()               //  Feet per Second to Knots
#define MPS_2_KNOTS           K::GMPS_2_KNOTS()             //  Meters per Second to Knots

//  ***  Conversions involving Units of Time  ***
#define MSEC_2_SEC            K::GMSEC_2_SEC()              //  Milliseconds per Second
#define SEC_2_MSEC            K::GSEC_2_MSEC()              //  Seconds to Milliseconds
#define HOURS_2_SECONDS       K::GHOURS_2_SECONDS()         //  Seconds per Hour
#define HOURS_2_MINUTES       K::GHOURS_2_MINUTES()         //  Hours to Minutes Conversion Factor

//  Standard Day
#define STD_DAY_TEMP          K::GSTD_DAY_TEMP()
#define STD_DAY_PRESS         K::GSTD_DAY_PRESS()

//  Flattening Factor and inverse
#define INV_FLATTENING_FACTOR K::GINV_FLATTENING_FACTOR()   //  Inverse of the Flattening Factor
#define FLATTENING_FACTOR     K::GFLATTENING_FACTOR()       //  Flattening Factor of the Earth set by NIMA Third Edition

//  Eccentricity
#define EARTH_ECCENTRICITY    K::GEARTH_ECCENTRICITY()

//  Earth Radius
#define EARTH_RADIUS_FEET     K::GEARTH_RADIUS_FEET()       //  Equatorial Earth Radius ( in Feet ) set by WGS84
#define EQUATORIAL_RADIUS_METERS K::GEQUATORIAL_RADIUS_METERS()  //  Equatorial Earth Radius

#define SQRT2                 K::GSQRT2()                   //  The Square Root of Two ( 2 )
#define ISQRT2                K::GISQRT2()                  //  One over the Square Root of Two ( 2 )


//#define ARC_2_NM              K::GARC_2_NM()                //  Arc Length to Nautical Miles Conversion Factor
//#define NM_2_ARC              K::GNM_2_ARC()                //  Nautical Miles to Arc Length Conversion Factor


//  ***  END Conversion Constants  ***



#endif   // __STDMATHCONSTANTS_H__

//all things that previously followed this are located in StdDefs.h 


/*************************************************************************
 *
 *   $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/StdMathConstants.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:35:02   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 12 2002 10:17:38   ShellM
 * Initial revision.
 * 
 ************************************************************************/

