/*
 *===========================================================================
 *
 *  HEADER FILE:  SharedResources.h
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
 *  $Workfile:   SharedResources.h  $
 *
 *  $Archive:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/SharedResources.h-arc  $
 *
 *  $Revision:   2.0  $
 *
 *  $Date:   Sep 03 2003 15:50:04  $
 *
 *  $Author:   JohnsT  $
 *
 *===========================================================================
 *
 *  Class Overview:
 *
 *  This file contains definitions required across process / project
 *  boundaries.
 *
 *===========================================================================
 */

//  Protect against multiple includes
#ifndef __SHAREDRESOURCES_H__
#define __SHAREDRESOURCES_H__


//  User-defined headers
// None.


//  Define Command/Message Queue names
#define SYSCTL_QUEUE_NAME                        "SYSCTLQ"
#define EXEC_SUBTASK_QUEUE_NAME                  "EXECSUBTASKQ"
#define EXEC_PHASED_INIT_ACK_QUEUE_NAME          "PHASEDINITACKQ"
#define TASK_STATUS_QUEUE_NAME                   "TASKSTATUSQ"
#define KICK_START_QUEUE_NAME                    "KickStartQ"       //  Use This Q for SysStart.exe
#define SIMCONTROL_QUEUE_NAME                    "SimController"
#define SUBTASK_QUEUE_NAME                       "SUBTASKQ"
#define PIM_MESSAGES_QUEUE_NAME      "ESMTaskCmdQ" 
#define ESM_COMMANDS_QUEUE_NAME      "ESMToCMCmdQ" 



//  All Messages must have correct prefixes indicating source of message attached
//  ( e.g. MASTEREXEC, SUBTASK, SIMCTRL, ... )

//  Messages from the SimController process (ONLY)
#define SIMCTRL_ABORT_CMD_MSG                 "SIMCTRL : ABORT CMD"
#define SIMCTRL_FREEZE_CMD_MSG                "SIMCTRL : FREEZE CMD"
#define SIMCTRL_INITIALIZETO_CMD_MSG          "SIMCTRL : INIT TO CMD"
#define SIMCTRL_RESET_CMD_MSG                 "SIMCTRL : RESET CMD"
#define SIMCTRL_RUN_CMD_MSG                   "SIMCTRL : RUN CMD"
#define SIMCTRL_SHUTDOWN_CMD_MSG              "SIMCTRL : SHUTDOWN CMD"
#define SIMCTRL_STARTUP_CMD_MSG               "SIMCTRL : STARTUP CMD"
#define SIMCTRL_STEP_CMD_MSG                  "SIMCTRL : STEP CMD"

//  Messages from a SysStart process
#define SYSSTART_SHUTDOWN_REQ_MSG             "SYSSTART : REQUEST SHUTDOWN MSG "

//  Messages from the MASTER Executive process (ONLY)
#define MASTEREXEC_APP_INIT_CMD_MSG           "MASTEREXEC : INITIALIZE APPLICATION CMD"
#define MASTEREXEC_APP_INIT_COMPLETE_MSG      "MASTEREXEC : ALL APP INITS COMPLETE MSG"
#define MASTEREXEC_MIRRORING_COMPLETE_MSG     "MASTEREXEC : MIRRORING COMPLETE MSG"
#define MASTEREXEC_QUEUE_INIT_ACK_MSG         "MASTEREXEC : QUEUE INIT ACK"

//  Messages from a SLAVE Executive process (ONLY)
#define SLAVEEXEC_QUEUE_INIT_COMPLETE_MSG     "SLAVEEXEC : QUEUE INIT COMPLETE MSG"
#define SLAVEEXEC_RESOURCE_INIT_COMPLETE_MSG  "SLAVEEXEC : RESOURCE INIT COMPLETE MSG"

//  Messages from an Executive process (GENERIC Executive)
#define EXECUTIVE_RESOURCE_INIT_CMD_MSG       "EXECUTIVE : RESOURCE INIT CMD"
#define EXECUTIVE_SHUTDOWN_CMD_MSG            "EXECUTIVE : SHUTDOWN CMD"
#define EXECUTIVE_SHUTDOWN_COMPLETE_MSG       "EXECUTIVE : SHUTDOWN COMPLETE MSG"

//  Messages from the subtask processes (GENERIC task, including SimController)
#define SUBTASK_APP_INIT_COMPLETE_MSG         "SUBTASK : APPLICATION INIT COMPLETE MSG $"
#define SUBTASK_RESOURCE_INIT_COMPLETE_MSG    "SUBTASK : RESOURCE INIT COMPLETE MSG $"
#define SUBTASK_SHUTDOWN_COMPLETE_MSG         "SUBTASK : SHUTDOWN COMPLETE MSG"

// Task/Process Status Reporting Message
#define PROCESS_STATUS_MSG                    "TASK : PROCESS STATUS MSG $"


//  Task Names for each process in the System
#define EXEC_TASK_NAME                           "Executive"


#endif   //  __SHAREDRESOURCES_H__


/*===========================================================================
 *
 *  Header Revision History
 *
 *  Rev     Date     Designer         Description of Change
 *  ------- -------- ---------------- ---------------------------------------
 *
 *   1.0    10/14/98 Cliff Brust      Initial Release
 *   2.0    06/22/01 Keith Radloff    Source Code Cleanup Pass
 *
 *===========================================================================
 *
 *  $Log:   T:/SmartDeck/archives/Flight_Display/Development/StdHeaders/SharedResources.h-arc  $
 * 
 *    Rev 2.0   Sep 03 2003 15:50:04   JohnsT
 * Rolling Revision number to 2.0. No changes, just new baseline.
 * 
 *    Rev 1.0   Sep 03 2003 15:43:12   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 20 2002 12:34:52   JohnsT
 * Initial revision.
 * 
 *    Rev 1.0   Dec 03 2002 16:03:28   ShellM
 * Initial revision.
 * 
 *    Rev 1.14   Jul 16 2002 13:11:34   EganC
 * Added ESM message queue names
 * 
 *    Rev 1.13   Dec 20 2001 16:50:26   RadloK
 * Post PVCS Project Reconstruction
 * 
 *    Rev 1.12   Dec 06 2001 16:39:12   RadloK
 * Removed #defined Task Names and Q Names
 * 
 *    Rev 1.11   Dec 05 2001 16:07:18   RadloK
 * Removed szaTaskName and thus the SysStart dependency on 
 * SharedResources.h
 * 
 *    Rev 1.10   Nov 28 2001 09:34:34   ZawodT
 * Added MASTEREXEC_QUEUE_INIT_ACK_MSG definition
 * 
 *    Rev 1.9   Nov 27 2001 15:39:44   ZawodT
 * Streamlined the contents --- got rid of redundant and inappropriate code lines.
 * 
 *    Rev 1.8   Oct 30 2001 12:16:54   ZawodT
 * Change SimControl Q name to be task name (SimController); allow for parameter in AppInitComplete message
 * 
 *    Rev 1.7   Oct 17 2001 10:47:16   RadloK
 * Modified the Control Queue Name
 * Change the Resource Init Complete Msg to handle params.
 * 
 *    Rev 1.6   Oct 12 2001 12:16:40   ZawodT
 * Re-enabled message names to allow current version of Executive to compile
 * 
 *    Rev 1.5   Oct 10 2001 16:46:50   ZawodT
 * Added PROCESS_STATUS_MSG definition
 * 
 *    Rev 1.4   Oct 10 2001 15:24:56   ZawodT
 * (Re)Declared message definitions and added TaskStatusQ
 * 
 *    Rev 1.3   Oct 09 2001 15:46:08   GeisD
 * Updated for BaseTask.
 * 
 *    Rev 1.2   Oct 08 2001 17:49:56   RadloK
 * Finalized BaseTask Project
 * Finalized Associated AppTemplate Templates
 * Updated the Documentation
 * Updated SharedResources.h
 * Verified Source ID Tracking Number Implementation
 * Updated to SmartDeck Method Return Standard
 * Updated to New Method Headers
 * Performed General Code Update Pass
 * 
 *    Rev 1.1   Sep 20 2001 09:00:48   GeisD
 * No longer include SMBLinks.h - not needed.
 * 
 *    Rev 1.0   Jul 05 2001 12:00:06   BrainL
 * Initial revision.
 *
 *===========================================================================

 
 *****  END of HEADER  *****
  
 */
