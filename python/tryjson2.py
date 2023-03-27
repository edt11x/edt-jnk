import json
from pprint import pprint

j = json.loads('{ "otpSemaphoreTiming": { "timeToWaitForMainTaskDelay": { "measurement": 391788, "atTime": 3206518776, "lastTime": 3205900723 } } }')
pprint(j)
