#!/bin/bash

MAQUINA=$HOST$HOSTNAME
mkdir configbackup.$MAQUINA

cp /etc/wandisco/fusion/server/core-site.xml ./configbackup.$MAQUINA/core-site.xml.server
cp /etc/wandisco/fusion/server/application.properties ./configbackup.$MAQUINA/application.properties
cp /etc/wandisco/fusion/ihc/server/hdi-4.0/core-site.xml ./configbackup.$MAQUINA/core-site.xml.ihv
cp /etc/wandisco/fusion/ihc/server/hdi-4.0/3.1.1.3.1.2.1-1.ihc ./configbackup.$MAQUINA/3.1.1.3.1.2.1-1.ihc
cp /opt/wandisco/fusion-ui-server/properties/ui.properties ./configbackup.$MAQUINA/ui.properties

tar -cvf $MAQUINA.tar ./configbackup.$MAQUINA
