import json
import numpy as np
import matplotlib.pyplot as plt
import math
import sys
from pprint import pprint
from time import gmtime, strftime, time
# from __future__ import print_function

MAIN_ALPHA = 0.00015

BUF_SIZE = 65536

mainFilt = 0
fcFilt = 0
fwFilt = 0
ogl1Filt = 0
ogl3Filt = 0
ogl1ExeFilt = 0
ogl3ExeFilt = 0
marvellFilt = 0
niu4Filt = 0
niu5Filt = 0
lastmainMeas = 0
lastmainAtTime = 0
lastMainLoopMeas = 0
lastMainLoopAtTime = 0
lastfcMeas = 0
lastfcAtTime = 0
lastogl1Meas = 0
lastogl1AtTime = 0
lastogl3Meas = 0
lastogl3AtTime = 0
lastMarvellMeas = 0
lastMarvellAtTime = 0
lastNIU4Meas = 0
lastNIU4AtTime = 0
lastNIU5Meas = 0
lastNIU5AtTime = 0
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
lastPlotTime = 0

def alphaFilter(filt, val):
    if (filt == 0):
        filt = val # seed the filter
    filt += (val - filt) * MAIN_ALPHA
    return filt

def _jsonMeas(meas):
    thisMeas = float('NaN')
    thisTime = 0
    if ("measurement" in meas) and ("atTime" in meas):
        thisMeas = meas["measurement"]
        thisTime = meas["atTime"]
    return (thisMeas, thisTime)

def jsonMeas(dict, name):
    if name in dict:
        return _jsonMeas(dict[name])
    return (float('NaN'), 0)

def jsonMeasIdx(dict, idx, name):
    if name in dict[idx]:
        return _jsonMeas(dict[idx][name])
    return (float('NaN'), 0)

bufsize = 0

plt.axis('auto')

plt.title('OTP Descheduled Time')
plt.xlabel('Processor Clock Microseconds')
plt.ylabel('Sleep in uSeconds or Kilobytes/second')
plt.ion()
plt.show()

with open(sys.argv[1], 'r') as f1:
    j = json.load(f1)
    if "otpTiming" in j:
        o = j["otpTiming"]
        mainLoopMeas, mainLoopAtTime = jsonMeas(o, "timeMainLoopCompleteTime")
        mainMeas, mainAtTime = jsonMeas(o, "timeToWaitForMainTaskDelay")
        fcMeas, fcAtTime = jsonMeas(o, "timeToWaitFCSyncSem")
        ogl1Meas, ogl1AtTime = jsonMeas(o, "timeToWaitOGL1SyncSem")
        ogl3Meas, ogl3AtTime = jsonMeas(o, "timeToWaitOGL3SyncSem")
        fwMeas, fwAtTime = jsonMeas(o, "timeToWaitForNextSTOF")
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
        marvellMeas, marvellAtTime = jsonMeas(o, "marvellDataRate")
        niu4Meas, niu4AtTime = jsonMeas(o, "niu4DataRate")
        niu5Meas, niu5AtTime = jsonMeas(o, "niu5DataRate")
# lets plot once every five seconds, plotting is really expensive
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
            if (marvellAtTime != lastMarvellAtTime) and (marvellMeas != 0):
                marvellFilt = alphaFilter(marvellFilt, marvellMeas)
            if (niu4AtTime != lastNIU4AtTime) and (niu4Meas != 0):
                niu4Filt = alphaFilter(niu4Filt, niu4Meas)
            if (niu5AtTime != lastNIU5AtTime) and (niu5Meas != 0):
                niu5Filt = alphaFilter(niu5Filt, niu5Meas)
        if time() > (lastPlotTime + 2):
            plt.plot(mainLoopAtTime,  mainLoopMeas, 'k1', label='Black Main Loop')
            plt.plot(mainAtTime,  mainMeas,    'r1', label='Red Main Sleep')
            # XXplt.plot(mainAtTime,  mainFilt,    'r+', label='Red Main Sleep')
            plt.plot(fcAtTime,    fcMeas,      'b2', label='Blue FC Sleep')
            # XXplt.plot(fcAtTime,    fcFilt,      'b+', label='Blue FC Sleep')
            plt.plot(ogl1AtTime,  ogl1Meas,    'g.', label='Green OGL1 Sleep')
            # XXplt.plot(ogl1AtTime,  ogl1Filt,    'g+', label='Green OGL1 Sleep')
            plt.plot(ogl3AtTime,  ogl3Meas,    'c.', label='Cyan OGL3 Sleep')
            # XXplt.plot(ogl3AtTime,  ogl3Filt,    'c+', label='Cyan OGL3 Sleep')
            plt.plot(fwAtTime,    fwMeas,      'kx', label='Black FW Sleep')
            # XXplt.plot(fwAtTime,    fwFilt,      'k+', label='Black FW Sleep')
            plt.plot(ogl1RecTime, ogl1RecMeas, 'r+')
            plt.plot(ogl1ExeTime, ogl1ExeMeas, 'g+')
            plt.plot(ogl1SndTime, ogl1SndMeas, 'b+')
            plt.plot(ogl3RecTime, ogl3RecMeas, 'c+')
            plt.plot(ogl3ExeTime, ogl3ExeMeas, 'm+')
            plt.plot(ogl3SndTime, ogl3SndMeas, 'k+')
            plt.plot(marvellAtTime, marvellMeas, color='pink',   marker='.', label='Marvell Data Rate')
            plt.plot(niu4AtTime,    niu4Meas,    color='orange', marker='.', label='NIU 4 Data Rate')
            plt.plot(niu5AtTime,    niu5Meas,    color='brown',  marker='.', label='NIU 5 Data Rate')
            if firstPlot:
                plt.legend(loc='upper center', fontsize='small')
                firstPlot = 0
            plt.draw()
            plt.pause(0.0001)
            lastPlotTime = time()
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
        lastMarvellMeas = marvellMeas
        lastMarvellAtTime = marvellAtTime
        lastNIU4Meas = niu4Meas
        lastNIU4AtTime = niu4AtTime
        lastNIU5Meas = niu5Meas
        lastNIU5AtTime = niu5AtTime
        print 'ML', int(mainLoopMeas), 'M', int(mainFilt), 'FC', int(fcFilt), 'FW', int(fwFilt), 'O1', int(ogl1Filt), 'O3', int(ogl3Filt)/4, 'MV', int(marvellFilt), 'N4', int(niu4Filt), 'N5', int(niu5Filt)
            # print mainAtTime,mainMeas

