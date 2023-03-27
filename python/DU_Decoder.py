# DU_Decoder.py

import struct
import sys
import numpy as np
import matplotlib.pyplot as plt

MAX_PACKET = 1024

if len(sys.argv) == 1:
    print "Need a file"
else:
    plt.axis('auto')
    plt.ion()
    plt.show()

    for i in range(1, len(sys.argv)):
        arg = sys.argv[i]
        print "Parsing File : " + arg
        try:
            f = open(arg, 'rb')
            bytes = f.read()
            huntingForAA = 1
            huntingForFF = 0
            packet = []
            for b in bytes:
                c = ord(b)
                if huntingForAA:
                    if (c == 0xAA):
                        huntingForAA = 0
                        huntingForFF = 1
                        packet = []
                        packet.append(c)
                        print "\nPacket\n%02X" % c,
                elif huntingForFF:
                    if ((len(packet) < MAX_PACKET) and (c != 0xFF)):
                        print "%02X" % c,
                        packet.append(c)
                    elif (len(packet) >= MAX_PACKET):
                        print "%02X" % c
                        print " XXX BAD PACKET, Aborting"
                        huntingForAA = 1
                        huntingForFF = 0
                    else:
                        print "%02X" % c
                        huntingForAA = 1
                        huntingForFF = 0
                        checksum = 0 # check the checksum
                        for j in range(0, len(packet)):
                            checksum = packet[j]
                        if ((checksum & 0x7F) != packet[len(packet)-1]) and (len(packet) > 2):
                            print "CHECKSUM MISMATCH 0x%02X vs 0x%02X" % ((checksum & 0x7F), packet[-1])
                        elif (len(packet) > 2) and (packet[1] == 0x12):
                            print "Touch Message"
                            print "X = %u, Y = %u" % (packet[2], packet[3])
                            if packet[4] == 1:
                                print "packet[4] = 1, Entry Point"
                                if packet[5] != 0:
                                    plt.plot(packet[2], packet[3], 'rx')
                                else:
                                    plt.plot(packet[2], packet[3], 'rD')
                            elif packet[4] == 2:
                                print "packet[4] = 2, Exit Point"
                                if packet[5] != 0:
                                    plt.plot(packet[2], packet[3], 'bx')
                                else:
                                    plt.plot(packet[2], packet[3], 'cD')
                            elif packet[4] == 3:
                                print "packet[4] = 3, Drag"
                                if packet[5] != 0:
                                    plt.plot(packet[2], packet[3], 'g+')
                                else:
                                    plt.plot(packet[2], packet[3], 'yD')
                            elif packet[4] == 4:
                                print "packet[4] = 4, Lack of Touch, No Touch Detected"
                            else:
                                print "Illegal Touch Detected Field, packet[4] == 0x%02X" % packet[4]
                            if packet[5] == 0:
                                print "packet[5] = 0, The coordinates are not valid (multiple touch event)"
                            elif packet[5] == 1:
                                print "packet[5] = 1, The coordinates are valid"
                            else:
                                print "Illegal Touch Error Field packet[5] = 0x%02X" % packet[5]
                            plt.draw()
                            plt.pause(0.0001)
        except IOError:
            print "File open failed: " + arg


