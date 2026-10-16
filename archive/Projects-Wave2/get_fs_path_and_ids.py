#!/usr/bin/python
import xml.etree.ElementTree as ET
import urllib2
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

fs = urllib2.urlopen("https://localhost:8084/fusion/fs", context=ctx).read()

root = ET.fromstring(fs)
sum = 0
for rd in root.findall(".//replicatedDirectory"):
        path = rd.find("./path")
        for location in rd.findall("./mappings//mapping[1]/location"):
                print(path.text + ", " + location.text)


