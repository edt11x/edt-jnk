import re
import socket
import json
import numpy as np
import matplotlib.pyplot as plt
from pprint import pprint
from sys import argv

script, filename = argv

MAIN_ALPHA = 0.03

mainFilt = 0
fcFilt = 0
fwFilt = 0
ogl1Filt = 0
ogl3Filt = 0
ogl1ExeFilt = 0
ogl3ExeFilt = 0
lastmainMeas = 0
lastmainAtTime = 0
lastfcMeas = 0
lastfcAtTime = 0
lastogl1Meas = 0
lastogl1AtTime = 0
lastogl3Meas = 0
lastogl3AtTime = 0
lastfwMeas = 0
lastfwAtTime = 0
lastogl1RecMeas = 0
lastogl1RecTime = 0
lastogl1ExeMeas = 0
lastogl1ExeTime = 0
lastogl1SndMeas = 0
lastogl1SndTime = 0
lastogl3RecMeas = 0
lastogl3RecTime = 0
lastogl3ExeMeas = 0
lastogl3ExeTime = 0
lastogl3SndMeas = 0
lastogl3SndTime = 0
firstPlot = 1
thisPlotCount = 0

def alphaFilter(filt, val):
    if (filt == 0):
        filt = val # seed the filter
    filt += (val - filt) * MAIN_ALPHA
    return filt


plt.axis('auto')

plt.title('OTP Descheduled Time')
plt.xlabel('Processor Clock Ticks')
plt.ylabel('Sleep in uSeconds')
plt.ion()

data = ''

with open(filename, 'r') as f:
    for chunk in f:
        data += chunk
        if re.match("^}$", chunk) and (not data is None):
            buffer = data
            data = ''
            try:
                j = json.loads(buffer)
                if "otpTiming" in j:
                    o = j["otpTiming"]
                    if "timeToWaitForMainTaskDelay" in o:
                        mtd = o["timeToWaitForMainTaskDelay"]
                        if ("measurement" in mtd) and ("atTime" in mtd):
                            mainMeas    = mtd["measurement"]
                            mainAtTime  = mtd["atTime"]
                    if "timeToWaitFCSyncSem" in o:
                        fcss = o["timeToWaitFCSyncSem"]
                        if ("measurement" in fcss) and ("atTime" in fcss):
                            fcMeas      = fcss["measurement"]
                            fcAtTime    = fcss["atTime"]
                    if "timeToWaitOGL1SyncSem" in o:
                        o1ss = o["timeToWaitOGL1SyncSem"]
                        if ("measurement" in o1ss) and ("atTime" in o1ss):
                            ogl1Meas    = o1ss["measurement"]
                            ogl1AtTime  = o1ss["atTime"]
                    if "timeToWaitOGL3SyncSem" in o:
                        o3ss = o["timeToWaitOGL3SyncSem"]
                        if ("measurement" in o3ss) and ("atTime" in o3ss):
                            ogl3Meas    = o3ss["measurement"] / 4
                            ogl3AtTime  = o3ss["atTime"]
                    if "timeToWaitForNextSTOF" in o:
                        fwns = o["timeToWaitForNextSTOF"]
                        if ("measurement" in fwns) and ("atTime" in fwns):
                            fwMeas      = fwns["measurement"]
                            fwAtTime    = fwns["atTime"]
                    if "driverTiming" in o:
                        dt = o["driverTiming"]
                        if "waitForReceive" in dt[0]:
                            wfr0 = dt[0]["waitForReceive"]
                            if ("measurement" in wfr0) and ("atTime" in wfr0):
                                ogl1RecMeas = wfr0["measurement"]
                                ogl1RecTime = wfr0["atTime"]
                        if "execute" in dt[0]:
                            exe0 = dt[0]["execute"]
                            if ("measurement" in exe0) and ("atTime" in exe0):
                                ogl1ExeMeas = exe0["measurement"]
                                ogl1ExeTime = exe0["atTime"]
                        if "waitForSend" in dt[0]:
                            wfs0 = dt[0]["waitForSend"]
                            if ("measurement" in wfs0) and ("atTime" in wfs0):
                                ogl1SndMeas = wfs0["measurement"]
                                ogl1SndTime = wfs0["atTime"]
                        if "waitForReceive" in dt[1]:
                            wfr1 = dt[1]["waitForReceive"]
                            if ("measurement" in wfr1) and ("atTime" in wfr1):
                                ogl3RecMeas = wfr1["measurement"]
                                ogl3RecTime = wfr1["atTime"]
                        if "execute" in dt[1]:
                            exe1 = dt[1]["execute"]
                            if ("measurement" in exe1) and ("atTime" in exe1):
                                ogl3ExeMeas = exe1["measurement"]
                                ogl3ExeTime = exe1["atTime"]
                        if "waitForSend" in dt[1]:
                            wfs1 = dt[1]["waitForSend"]
                            if ("measurement" in wfs1) and ("atTime" in wfs1):
                                ogl3SndMeas = wfs1["measurement"]
                                ogl3SndTime = wfs1["atTime"]
                if (not mainMeas is None) and (not mainAtTime is None):
                    if (mainAtTime != lastmainAtTime) and (mainAtTime != 0):
                        mainFilt = alphaFilter(mainFilt, mainMeas)
                    if (fcAtTime != lastfcAtTime) and (fcAtTime != 0):
                        fcFilt = alphaFilter(fcFilt, fcMeas)
                    if (ogl1AtTime != lastogl1AtTime) and (ogl1AtTime != 0):
                        ogl1Filt = alphaFilter(ogl1Filt, ogl1Meas)
                    if (ogl3AtTime != lastogl3AtTime) and (ogl3AtTime != 0):
                        ogl3Filt = alphaFilter(ogl3Filt, ogl3Meas)
                    if (fwAtTime != lastfwAtTime) and (fwAtTime != 0):
                        fwFilt = alphaFilter(fwFilt, fwMeas)
                    if (ogl1ExeTime != lastogl1ExeTime) and (ogl1ExeTime != 0):
                        ogl1ExeFilt = alphaFilter(ogl1ExeFilt, ogl1ExeMeas)
                    if (ogl3ExeTime != lastogl3ExeTime) and (ogl3ExeTime != 0):
                        ogl3ExeFilt = alphaFilter(ogl3ExeFilt, ogl3ExeMeas)
                    plt.plot(mainAtTime,  mainMeas,    'r1')
                    plt.plot(mainAtTime,  mainFilt,    'r+', label='Red Main Sleep')
                    plt.plot(fcAtTime,    fcMeas,      'b2')
                    plt.plot(fcAtTime,    fcFilt,      'b+', label='Blue FC Sleep')
                    plt.plot(ogl1AtTime,  ogl1Meas,    'g3')
                    plt.plot(ogl1AtTime,  ogl1Filt,    'g+', label='Green OGL1 Sleep')
                    plt.plot(ogl3AtTime,  ogl3Meas,    'c4')
                    plt.plot(ogl3AtTime,  ogl3Filt,    'c+', label='Cyan OGL3 Sleep')
                    plt.plot(fwAtTime,    fwMeas,      'kx')
                    plt.plot(fwAtTime,    fwFilt,      'k+', label='Black FW Sleep')
                    plt.plot(ogl1RecTime, ogl1RecMeas, 'r.')
                    plt.plot(ogl1ExeTime, ogl1ExeMeas, 'g.')
                    plt.plot(ogl1SndTime, ogl1SndMeas, 'b.')
                    plt.plot(ogl3RecTime, ogl3RecMeas, 'c.')
                    plt.plot(ogl3ExeTime, ogl3ExeMeas, 'm.')
                    plt.plot(ogl3SndTime, ogl3SndMeas, 'k.')
                    if firstPlot:
                        plt.legend(loc='upper center', fontsize='small')
                        firstPlot = 0
                    if thisPlotCount == 100:
                        plt.draw()
                        plt.pause(0.0001)
                        thisPlotCount = 0
                    thisPlotCount += 1
                    plt.pause(0.0001)
                    lastmainMeas = mainMeas
                    lastmainAtTime = mainAtTime
                    lastfcMeas = fcMeas
                    lastfcAtTime = fcAtTime
                    lastogl1Meas = ogl1Meas
                    lastogl1AtTime = ogl1AtTime
                    lastogl3Meas = ogl3Meas
                    lastogl3AtTime = ogl3AtTime
                    lastfwMeas = fwMeas
                    lastfwAtTime = fwAtTime
                    lastogl1RecMeas = ogl1RecMeas
                    lastogl1RecTime = ogl1RecTime
                    lastogl1ExeMeas = ogl1ExeMeas
                    lastogl1ExeTime = ogl1ExeTime
                    lastogl1SndMeas = ogl1SndMeas
                    lastogl1SndTime = ogl1SndTime
                    lastogl3RecMeas = ogl3RecMeas
                    lastogl3RecTime = ogl3RecTime
                    lastogl3ExeMeas = ogl3ExeMeas
                    lastogl3ExeTime = ogl3ExeTime
                    lastogl3SndMeas = ogl3SndMeas
                    lastogl3SndTime = ogl3SndTime
                    print 'Main', int(mainFilt), 'FC', int(fcFilt), 'FW', int(fwFilt), 'OGL1', int(ogl1Filt), 'OGL3', int(ogl3Filt), 'OGL1EXE', int(ogl1ExeFilt), 'OGL3EXE', int(ogl3ExeFilt)
                # print mainAtTime,mainMeas
            except ValueError:
                pass
plt.draw()
plt.show()
print 'Done'
while True:
    plt.pause(0.0001)

