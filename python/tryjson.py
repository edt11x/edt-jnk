import json
from pprint import pprint

j = json.loads('{"one" : "1", "two" : "2", "three" : "3"}')
print j['two']
pprint(j)