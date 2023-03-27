import socket
import json
from pprint import pprint

UDP_IP = "0.0.0.0"
UDP_PORT = 7100

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

while True:
    data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
    j = json.loads(data)
    meas = j["otpTiming"]["timeToWaitForMainTaskDelay"]["measurement"]
    atTime = j["otpTiming"]["timeToWaitForMainTaskDelay"]["atTime"]
    print atTime,meas

