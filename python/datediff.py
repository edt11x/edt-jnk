#!/usr/bin/env python
import sys
from datetime import datetime

FMT = sys.argv[1]
s1  = sys.argv[2]
s2  = sys.argv[3]
print 'Format :', sys.argv[1]
print 'Date 1 :', sys.argv[2]
print 'Date 2 :', sys.argv[3]
tdelta = datetime.strptime(s2, FMT) - datetime.strptime(s1, FMT)
print tdelta
print tdelta.total_seconds()
