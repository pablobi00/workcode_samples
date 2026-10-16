#!/usr/bin/python
import xml.etree.ElementTree as ET
import urllib2
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

migrations = urllib2.urlopen("https://localhost:8084/plugins/migrator/getAll", context=ctx).read()
fs = urllib2.urlopen("https://localhost:8084/fusion/fs", context=ctx).read()

migroot = ET.fromstring(migrations)
fsroot = ET.fromstring(fs)

sum = 0
for tt in migroot.findall(".//migration"):
        migrationPath = tt.find("./migrationPath")
        migrationId = tt.find("./migrationId")
        migrationState = tt.find("./state")
        for rd in fsroot.findall(".//replicatedDirectory"):
                path = rd.find("./path")
                if path.text == migrationPath.text:
                        locations = rd.findall("./mappings//mapping[1]/location")
                        print migrationId.text, migrationState.text, migrationPath.text, locations[0].text


