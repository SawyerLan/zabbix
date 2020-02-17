#!/bin/env python

import json
import sys

file = sys.argv[1]

with open(file) as f:
    t = f.readlines()

content = [ [x.strip().split()[0], x.strip().split()[1] ] for x in t]
data = list()
for i in content:
    t = dict()
    t['{#SERVICE}'] = i[0]
    t['{#PORT}'] = i[1]
    data.append(t)
zbx_data = dict()
zbx_data['data'] = data
print json.dumps(zbx_data,indent=4)
