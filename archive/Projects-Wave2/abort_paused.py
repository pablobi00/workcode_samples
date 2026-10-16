#!/usr/bin/python
import xml.etree.ElementTree as ET
import urllib2
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

class MethodRequest(urllib2.Request):
    def __init__(self, *args, **kwargs):
        if 'method' in kwargs:
            self._method = kwargs['method']
            del kwargs['method']
        else:
            self._method = None
        return urllib2.Request.__init__(self, *args, **kwargs)

    def get_method(self, *args, **kwargs):
        if self._method is not None:
            return self._method
        return urllib2.Request.get_method(self, *args, **kwargs)

migrations = urllib2.urlopen("https://localhost:8084/plugins/migrator/getAll", context=ctx).read()

root = ET.fromstring(migrations)
for tt in root.findall(".//*[state='PAUSED']/migrationId"):
        migration_id =  tt.text
        print("Aborting " + migration_id)
        req = MethodRequest("https://localhost:8084/plugins/migrator/" + migration_id + "/abort", method='PUT')
        urllib2.urlopen(req, context=ctx).read()


