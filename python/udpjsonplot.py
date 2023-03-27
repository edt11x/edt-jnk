import socket
import json
import numpy as np
import matplotlib.pyplot as plt
from pprint import pprint

UDP_IP = "0.0.0.0"
UDP_PORT = 7100

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

# plt.axis([59160613750,60000000000, 300000, 500000])
plt.axis('auto')
plt.ion()
plt.show()

while True:
    data, addr = sock.recvfrom(65536) # buffer size is 1024 bytes
    if (not data is None):
        try:
            j = json.loads(data)
            meas = j["otpTiming"]["timeToWaitForMainTaskDelay"]["measurement"]
            atTime = j["otpTiming"]["timeToWaitForMainTaskDelay"]["atTime"]
            if (not meas is None) and (not atTime is None) and (meas > 10000) and (atTime > 10000):
                plt.scatter(atTime, meas)
                plt.draw()
                plt.pause(0.0001)
            # print atTime,meas
        except ValueError:
            pass

