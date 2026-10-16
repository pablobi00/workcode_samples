#!/usr/bin/python3

import json
import requests
from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
# Diagnostics summaries

# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


# List of diagnostics Kind - curl http://<server>:18080/diagnosticsdescriptions

kinds = (
    "EventManagerDiagnostic",
    "JvmGcDiagnostic",
    "LinuxPressureDiagnostic",
    "MigrationsDiagnostic",
    "InotifyDiagnostic",
    "NetworkStatus",
    "CpuLoadDiagnostic",
    "FileTrackerDiagnostic",
    "ThroughputDiagnostic"
)

# LDM URL

ldmurl='http://44.230.76.62'

print (cBlue+'\n======================================\nSource:',ldmurl,'\n======================================\n'+cReset)

# Diagnostics information

print (cBlue+'\n---------------------- DIAGNOSTICS UPDATE ------------------------------------------------------\n'+cReset)

uglyDiagnostics = (requests.get(ldmurl + ':18080/diagnostics/collect').json())
print (json.dumps(uglyDiagnostics, indent=4))

print (cBlue+'\n---------------------- DIAGNOSTICS SUMMARY ------------------------------------------------------\n'+cReset)

uglyDiagnostics = (requests.get(ldmurl + ':18080/diagnostics/summary').json())
print (json.dumps(uglyDiagnostics, indent=4))

print (cBlue+'\n---------------------- THROUGHPUT LAST 60 SECONDS ------------------------------------------------------\n'+cReset)

uglyDiagnostics = (requests.get(ldmurl + ':18080/diagnostics/lastCollected?kind=ThroughputDiagnostic').json())
print (json.dumps(uglyDiagnostics, indent=4))

print (cBlue+'\n----------------------  MIGRATIONS DIAGNOSTICS ------------------------------------------------------\n'+cReset)

uglyDiagnostics = (requests.get(ldmurl + ':18080/diagnostics/lastCollected?kind=MigrationsDiagnostic').json())
print (json.dumps(uglyDiagnostics, indent=4))

print (cBlue+'\n[EOF]\n'+cReset)
