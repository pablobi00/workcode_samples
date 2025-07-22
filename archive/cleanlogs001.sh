#!/bin/bash

# gen1server1
# use tar -uzvf to update february on next iterations

cd /var/log/fusion/server/

# fusion-events

tar -czvf gen1server1-events-jan.tgz fusion-events.log.2020-01-*
tar -czvf gen1server1-events-feb.tgz fusion-events.log.2020-02-*

rm fusion-events.log.2020-01-*

# migration-audit

tar -czvf gen1server1-migration-jan.tgz fusion-migration-audit.log.2020-01-*
tar -czvf gen1server1-migration-feb.tgz fusion-migration-audit.log.2020-02-*

rm fusion-migration-audit.log.2020-01-*

# fusion-server

tar -czvf gen1server1-server-jan.tgz fusion-server.log.2020-01-*
tar -czvf gen1server1-server-feb.tgz fusion-server.log.2020-02-*

rm fusion-server.log.2020-01-*

# http_access and gc.log 

rm http_access.log.*
rm gc.log.*

# ihc

cd /var/log/fusion/ihc/server/

tar -czvf gen1server1-ihc-jan.tgz fusion-ihc-hdi-4.0.log.2020-01-*
tar -czvf gen1server1-ihc-feb.tgz fusion-ihc-hdi-4.0.log.2020-02-*

rm fusion-ihc-hdi-4.0.log.2020-01-*

# ui

cd /var/log/fusion/ui/

tar -czvf gen1server1-ui-jan.tgz fusion-ui-2020-01-*
tar -czvf gen1server1-ui-feb.tgz fusion-ui-2020-02-*

rm fusion-ui-2020-01-*

printf '\n=====\[EOF]\n'

