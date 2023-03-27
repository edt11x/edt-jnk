from cStringIO import StringIO
import socket
import json
import matplotlib.pyplot as plt
import math
import os
import re
import string
import sys
from pprint import pprint
from time import gmtime, strftime, time

UDP_IP = "0.0.0.0"
UDP_PORT = 7100
LOG_DIR = "C:\\JSF PCD EU MTE Software\\Log Files"
MAIN_ALPHA = 0.00015
BUF_SIZE = 65536
FRAMES_PER_SECOND = 60

def alphaFilter(filt, val, thisTime, lastTime):
    if (thisTime != lastTime) and (thisTime != 0):
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

def doplot(thisTime = 0, thisMeas = 0, *args, **kwargs):
    if ((not math.isnan(thisTime)) and 
            (not math.isnan(thisMeas)) and 
            (thisTime > 100000000) and 
            (thisTime < 1e10)):
        plt.plot(thisTime, thisMeas, *args, **kwargs)

def is_ascii(s):
    isprintable = set(s).issubset(set(string.printable))
    if isprintable:
        return True
    else:
        return False


def jsonData(data):
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
    l2CacheMissFilt = 1.70e6
    l2CacheMissFiltAtTime = 0
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
    lastPlotTime = 0
    firstPlot = 1
    if (not data is None):
        if not os.path.isdir(LOG_DIR):
            os.makedirs(LOG_DIR)
        file1 = LOG_DIR + strftime("\\Perf-SP-Left-%Y-%m-%d-%H%M%S.log", gmtime())
        file2 = LOG_DIR + strftime("\\JSON-SP-Left-%Y-%m-%d-%H%M%S.log", gmtime())
        bufsize = 0
        f1 = open(file1, 'w+', bufsize)
        f2 = open(file2, 'w+', bufsize)
        plt.axis('auto')
        plt.title('OTP Cache Measurements')
        plt.xlabel('Processor Clock Microseconds')
        plt.ylabel('Counts per Second')
        plt.ion()
        plt.show()
        # data = filter(lambda x: x in set(string.printable), data)
        match_close = re.compile("^\s*}")
        match_comma_comma = re.compile("^.*,.*,")
        match_digit_space_digit = re.compile("\d\s+\d")
        match_key_no_colon = re.compile("^\s*\"\w+\"[^:]")
        match_line_colon_colon = re.compile(":.*:")
        match_line_colon_comma = re.compile(":\s*,")
        match_line_colon_end = re.compile(":\s*$")
        match_line_comma = re.compile("^\s*,\s*$")
        match_line_ends_in_comma = re.compile(",\s*$")
        match_line_start_w_number = re.compile("^\s*\d")
        match_measurement_wo_comma = re.compile("\"measurement\": \d*[^,]$")
        match_object_begin = re.compile("^{")
        match_object_end   = re.compile("^}")
        match_open_brace_space_close_brace = re.compile("}\s*{")
        match_open_brace_space_open_brace = re.compile("{\s*{")
        match_close_brace_space_close_brace = re.compile("}\s*}")
        match_opens = re.compile('.*{')
        match_quote_missing_quote = re.compile("^[^\"]*\"[^\"]*$")
        match_quote_quote = re.compile("\"\s*\"")
        match_quote_quote_quote = re.compile("\"[^\"]+\"[^\"]+\"")
        match_quote_space_quote = re.compile("\"\s+\"")
        match_quote_colon_number_no_comma = re.compile("\"atTime\":\s*\d+$")
        inside_object = False
        count_opens = 0
        count_close = 0
        result = ""
        buffer = ""
        line_count = 0
        data_list = []
        first_object = True
        this_line_is_comma = False
        this_line_ends_in_comma = False
        last_line_ends_in_comma = False
        for i in data.replace("\r", "").splitlines():
            last_line_ends_in_comma = this_line_ends_in_comma
            line_count += 1
            if inside_object:
                buffer += (i + "\n")
                if match_line_comma.match(i):
                    this_line_is_comma = True
                else:
                    this_line_is_comma = False
                if match_line_ends_in_comma.search(i):
                    this_line_ends_in_comma = True
                else:
                    this_line_ends_in_comma = False
                if (match_quote_quote.search(i) or 
                    match_comma_comma.search(i) or 
                    match_quote_missing_quote.search(i) or 
                    match_quote_quote_quote.search(i) or 
                    match_quote_space_quote.search(i) or 
                    match_key_no_colon.search(i) or 
                    match_line_start_w_number.match(i) or 
                    match_line_colon_end.search(i) or
                    match_line_colon_comma.search(i) or
                    match_line_colon_colon.search(i) or
                    match_open_brace_space_close_brace.search(i) or
                    match_open_brace_space_open_brace.search(i) or
                    match_close_brace_space_close_brace.search(i) or
                    match_digit_space_digit.search(i) or
                    match_quote_colon_number_no_comma.search(i) or
                    match_measurement_wo_comma.search(i) or
                    (not is_ascii(i)) or
                    (this_line_is_comma and last_line_ends_in_comma)):
                    inside_object = False
                    print 'Found failure at line %d' % line_count
                    print 'Line is %s' % i
                elif match_object_begin.match(i): # throw it out start again
                    count_opens = 1
                    count_close = 0
                    if first_object:
                        buffer = "[\n" + i + "\n"
                        first_object = False
                    else:
                        buffer = ",\n" + i + "\n"
                elif match_object_end.match(i):
                    count_close += 1
                    if (count_opens > 1) and (count_close > 1) and (count_opens == count_close):
                        result += buffer
                    inside_object = False
                elif match_opens.match(i):
                    count_opens += 1
                elif match_close.match(i):
                    count_close += 1
            else:
                if match_object_begin.match(i):
                    inside_object = True
                    count_opens = 1
                    count_close = 0
                    if first_object:
                        buffer = "[\n" + i + "\n"
                        first_object = False
                    else:
                        buffer = ",\n" + i + "\n"
        if first_object:
            data = ""
        else:
            data = result + "]\n"

        print >>f2, data
# we use json.loads(), load from a string, rather than json.load, load from a
# file object, since we may be replaying the data from a file or reading from a
# socket, or maybe doing something else.
        count = 0
        for j in json.loads(data): # anonymous array of OTP records
            count += 1
            mainLoopMeas, mainLoopAtTime = jsonMeas(j["otpTiming"], "timeMainLoopCompleteTime")
            mainMeas, mainAtTime = jsonMeas(j["otpTiming"], "timeToWaitForMainTaskDelay")
            fcMeas, fcAtTime = jsonMeas(j["otpTiming"], "timeToWaitFCSyncSem")
            ogl1Meas, ogl1AtTime = jsonMeas(j["otpTiming"], "timeToWaitOGL1SyncSem")
            ogl3Meas, ogl3AtTime = jsonMeas(j["otpTiming"], "timeToWaitOGL3SyncSem")
            fwMeas, fwAtTime = jsonMeas(j["otpTiming"], "timeToWaitForNextSTOF")
            marvellMeas, marvellAtTime = jsonMeas(j["otpTiming"], "marvellDataRate")
            niu4Meas, niu4AtTime = jsonMeas(j["otpTiming"], "niu4DataRate")
            niu5Meas, niu5AtTime = jsonMeas(j["otpTiming"], "niu5DataRate")
# lets plot once every five seconds, plotting is really expensive
            if (not mainMeas is None) and (not mainAtTime is None):
                mainFilt = alphaFilter(mainFilt, mainMeas, mainAtTime, lastmainAtTime)
                fcFilt = alphaFilter(fcFilt, fcMeas, fcAtTime, lastfcAtTime)
                ogl1Filt = alphaFilter(ogl1Filt, ogl1Meas, ogl1AtTime, lastogl1AtTime)
                ogl3Filt = alphaFilter(ogl3Filt, ogl3Meas, ogl3AtTime, lastogl3AtTime)
                fwFilt = alphaFilter(fwFilt, fwMeas, fwAtTime, lastfwAtTime)
                try:
                    ogl1ExeFilt = alphaFilter(ogl1ExeFilt, 
                        j["otpTiming"]["driverTiming"][0]["execute"]["measurement"], 
                        j["otpTiming"]["driverTiming"][0]["execute"]["atTime"], lastogl1ExeTime)
                    ogl3ExeFilt = alphaFilter(ogl3ExeFilt, 
                        j["otpTiming"]["driverTiming"][1]["execute"]["measurement"], 
                        j["otpTiming"]["driverTiming"][1]["execute"]["atTime"], lastogl3ExeTime)
                except KeyError:
                    pass
                marvellFilt = alphaFilter(marvellFilt, marvellMeas, marvellAtTime, lastMarvellAtTime)
                niu4Filt = alphaFilter(niu4Filt, niu4Meas, niu4AtTime, lastNIU4AtTime)
                niu5Filt = alphaFilter(niu5Filt, niu5Meas, niu5AtTime, lastNIU5AtTime)
            # doplot(mainLoopAtTime,  mainLoopMeas, 'k1', label='Black Main Loop')
            # doplot(mainAtTime,  mainMeas,    'r1', label='Red Main Sleep')
            # XXdoplot(mainAtTime,  mainFilt,    'r+', label='Red Main Sleep')
            # doplot(fcAtTime,    fcMeas,      'b2', label='Blue FC Sleep')
            # XXdoplot(fcAtTime,    fcFilt,      'b+', label='Blue FC Sleep')
            # doplot(ogl1AtTime,  ogl1Meas,    'g.', label='Green OGL1 Sleep')
            # XXdoplot(ogl1AtTime,  ogl1Filt,    'g+', label='Green OGL1 Sleep')
            # doplot(ogl3AtTime,  ogl3Meas/4,    'c.', label='Cyan OGL3 Sleep')
            # XXdoplot(ogl3AtTime,  ogl3Filt/4,    'c+', label='Cyan OGL3 Sleep')
            # doplot(fwAtTime,    fwMeas,      'kx', label='Black FW Sleep')
            # XXdoplot(fwAtTime,    fwFilt,      'k+', label='Black FW Sleep')
            try:
#                doplot(j["otpTiming"]["PMC"]["atTime"],
#                        j["otpTiming"]["PMC"]["pmc1"]["measurementValue"] * FRAMES_PER_SECOND,
#                        color='green', marker='x', label='L1 Instr Cache Misses')
#                doplot(j["otpTiming"]["PMC"]["atTime"],
#                        j["otpTiming"]["PMC"]["pmc2"]["measurementValue"] * FRAMES_PER_SECOND,
#                        color='orange', marker='x', label='L1 Data Total Misses')
#                doplot(j["otpTiming"]["PMC"]["atTime"],
#                        j["otpTiming"]["PMC"]["pmc4"]["measurementValue"] * FRAMES_PER_SECOND,
#                        color='pink', marker='x', label='InstrCompleted')
                doplot(j["otpTiming"]["PMC"]["atTime"],
                       j["otpTiming"]["PMC"]["pmc1"]["measurementValue"] * FRAMES_PER_SECOND,
                       color='orange', marker='x', label='L1 Instr Cache Misses')
                doplot(j["otpTiming"]["PMC"]["atTime"],
                       j["otpTiming"]["PMC"]["pmc2"]["measurementValue"] * FRAMES_PER_SECOND,
                       color='pink', marker='x', label='L1 Data Cache Misses')
                doplot(j["otpTiming"]["PMC"]["atTime"],
                       j["otpTiming"]["PMC"]["pmc3"]["measurementValue"] * FRAMES_PER_SECOND,
                       color='cyan', marker='x', label='L1 Data Cache Hits')
                doplot(j["otpTiming"]["PMC"]["atTime"],
                       j["otpTiming"]["PMC"]["pmc4"]["measurementValue"] * FRAMES_PER_SECOND / 100,
                       color='blue', marker='x', label='Hundreds Instr Completed')
                l2CacheMissFilt = alphaFilter(l2CacheMissFilt, 
                        j["otpTiming"]["PMC"]["pmc5"]["measurementValue"] * FRAMES_PER_SECOND,
                        j["otpTiming"]["PMC"]["atTime"],
                        l2CacheMissFiltAtTime)
                doplot(j["otpTiming"]["PMC"]["atTime"],
                        j["otpTiming"]["PMC"]["pmc5"]["measurementValue"] * FRAMES_PER_SECOND,
                        color='red', marker='x', label='L2 Cache Misses')
                l2CacheMissFiltAtTime = j["otpTiming"]["PMC"]["atTime"]
                doplot(l2CacheMissFiltAtTime, l2CacheMissFilt, color='green', marker='+',
                        label='Alpha Filtered L2 Cache Misses')
                doplot(j["otpTiming"]["PMC"]["atTime"],
                       j["otpTiming"]["PMC"]["pmc6"]["measurementValue"] * FRAMES_PER_SECOND,
                       color='black', marker='x', label='L2 Cache Hits')
#                doplot(j["otpTiming"]["driverTiming"][0]["waitForReceive"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][0]["waitForReceive"]["measurement"], 'r+')
#                doplot(j["otpTiming"]["driverTiming"][0]["execute"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][0]["execute"]["measurement"], 'g+')
#                doplot(j["otpTiming"]["driverTiming"][0]["waitForSend"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][0]["waitForSend"]["measurement"], 'b+')
#                doplot(j["otpTiming"]["driverTiming"][1]["waitForReceive"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][1]["waitForReceive"]["measurement"], 'c+')
#                doplot(j["otpTiming"]["driverTiming"][1]["execute"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][1]["execute"]["measurement"], 'm+')
#                doplot(j["otpTiming"]["driverTiming"][1]["waitForSend"]["atTime"], 
#                         j["otpTiming"]["driverTiming"][1]["waitForSend"]["measurement"], 'k+')
            except KeyError:
                pass
            #doplot(marvellAtTime, marvellMeas, color='pink',   marker='.', label='Marvell Data Rate')
            #doplot(niu4AtTime,    niu4Meas,    color='orange', marker='.', label='NIU 4 Data Rate')
            #doplot(niu5AtTime,    niu5Meas,    color='brown',  marker='.', label='NIU 5 Data Rate')
            if firstPlot:
                plt.legend(loc='upper center', fontsize='small')
                firstPlot = 0
            if (time() > (lastPlotTime+5)):
                plt.draw() # watch this -- plt.draw() redraws everything, which is expensive
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
            try:
                lastogl1RecMeas = j["otpTiming"]["driverTiming"][0]["waitForReceive"]["measurement"]
                lastogl1RecTime = j["otpTiming"]["driverTiming"][0]["waitForReceive"]["atTime"]
                lastogl1ExeMeas = j["otpTiming"]["driverTiming"][0]["execute"]["measurement"]
                lastogl1ExeTime = j["otpTiming"]["driverTiming"][0]["execute"]["atTime"]
                lastogl1SndMeas = j["otpTiming"]["driverTiming"][0]["waitForSend"]["measurement"]
                lastogl1SndTime = j["otpTiming"]["driverTiming"][0]["waitForSend"]["atTime"]
                lastogl3RecMeas = j["otpTiming"]["driverTiming"][1]["waitForReceive"]["measurement"]
                lastogl3RecTime = j["otpTiming"]["driverTiming"][1]["waitForReceive"]["atTime"]
                lastogl3ExeMeas = j["otpTiming"]["driverTiming"][1]["execute"]["measurement"]
                lastogl3ExeTime = j["otpTiming"]["driverTiming"][1]["execute"]["atTime"]
                lastogl3SndMeas = j["otpTiming"]["driverTiming"][1]["waitForSend"]["measurement"]
            except KeyError:
                pass
            lastMarvellAtTime = marvellAtTime
            lastNIU4Meas = niu4Meas
            lastNIU4AtTime = niu4AtTime
            lastNIU5Meas = niu5Meas
            lastNIU5AtTime = niu5AtTime
            print 'ML', int(mainLoopMeas), 'M', int(mainFilt), 'FC', int(fcFilt), 'FW', int(fwFilt), 'O1', int(ogl1Filt), 'O3', int(ogl3Filt)/4, 'MV', int(marvellFilt), 'N4', int(niu4Filt), 'N5', int(niu5Filt), 'L2', int(l2CacheMissFilt/1e4)
            print >>f1, 'ML', int(mainLoopMeas), 'M', int(mainFilt), 'FC', int(fcFilt), 'FW', int(fwFilt), 'O1', int(ogl1Filt), 'O3', int(ogl3Filt)/4, 'MV', int(marvellFilt), 'N4', int(niu4Filt), 'N5', int(niu5Filt), 'L2', int(l2CacheMissFilt/1e4)

if len(sys.argv) <= 1:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
    sock.bind((UDP_IP, UDP_PORT))
    while True:
        data, addr = sock.recvfrom(BUF_SIZE) # read a buffer
        jsonData(data)
else: # must be a file to open
    for filename in sys.argv[1:]:
        with open(filename,'r') as afile:
                data = afile.read()
                jsonData(data)
    print 'Done.'
    plt.show(block=True)
