#!/usr/bin/env bash

ABORT # curl --insecure -X PUT https://localhost:8084/plugins/migrator/<migrationId>/abort

RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=< /WD-path >&donor=zone-central&beneficiary=zoneG2-central&startPath=< migrationEdge without WD-path and / >&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=10000&pollTimer=1&dateAfterWhichToMigrate=0"

============================================================

02-15 11:10

small /data/raw/Marketing/AdActivity/Neustar/ver=01/
running in all g1

56ef9b7e-4fc0-11ea-a818-000d3aa4136c
/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c
LoadDate=20180729/events/2018/07/28/v1/collected_attributes/8099/9539/2018_07/part-06897.gz

curl --insecure -X PUT https://localhost:8084/plugins/migrator/56ef9b7e-4fc0-11ea-a818-000d3aa4136c/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20180729/events/2018/07/28/v1/collected_attributes/8099/9539/2018_07/part-06897.gz&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"




================================================================
02-14 22:30
small /data/raw/Marketing/AdActivity/Neustar/ver=01/
running in g1s1
aborted in g1s2

7c8c89f0-4f59-11ea-a818-000d3aa4136c
/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c
LoadDate=20180712/events/2018/07/11/v1/collected_attributes/379/655/2018_07/part-04653.gz

# curl --insecure -X PUT https://localhost:8084/plugins/migrator/7c8c89f0-4f59-11ea-a818-000d3aa4136c/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20180712/events/2018/07/11/v1/collected_attributes/379/655/2018_07/part-04653.gz&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"


PAUSED
/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab  ->  BIG /data/raw/Marketing/AdActivity/Neustar/ver=02/
/WD-VIRTUAL-f4f98b15-4aa7-11ea-9047-000d3aa50bab  --> BIG /data/published/Marketing/Campaign/FormationImportUserRestricted/ver=01/


==========================

02.14-10:15

BIG /data/published/Marketing/Campaign/FormationImportUserRestricted/ver=01/
aborted in g1s1
running in g1s2

 <migrationId>80b8d777-4ef6-11ea-b8ab-000d3aa50bab</migrationId>
 <migrationPath>/WD-VIRTUAL-f4f98b15-4aa7-11ea-9047-000d3aa50bab</migrationPath>
 PublishedDate=2018-01-23/part-00693-d2da5405-f977-44b0-85a8-37b53661f4ab.c000.snappy.parquet

ABORT # curl --insecure -X PUT https://localhost:8084/plugins/migrator/80b8d777-4ef6-11ea-b8ab-000d3aa50bab/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-f4f98b15-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=PublishedDate=2018-01-23/part-00693-d2da5405-f977-44b0-85a8-37b53661f4ab.c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"


BIG /data/raw/Marketing/AdActivity/Neustar/ver=02/
aborted in g1s1
running  in g1s2

    <migrationId>5e074e76-4e87-11ea-b1cc-000d3aa50bab</migrationId>
    <migrationPath>/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab</migrationPath>
    LoadDate=20200125/events/2020/01/24/collected_attributes/278/12894/2020_01/part-01690-tid-1649536628842501775-937df986-220e-4ece-8509-a09b3a7c3222-7495-1-c000.snappy.parquet


ABORT # curl --insecure -X PUT https://localhost:8084/plugins/migrator/5e074e76-4e87-11ea-b1cc-000d3aa50bab/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20200125/events/2020/01/24/collected_attributes/278/12894/2020_01/part-01690-tid-1649536628842501775-937df986-220e-4ece-8509-a09b3a7c3222-7495-1-c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"


small /data/raw/Marketing/AdActivity/Neustar/ver=01/
Running on g1s1
Aborted in g1s2
<migrationId>f836e5ad-4ef6-11ea-a818-000d3aa4136c</migrationId>
<migrationPath>/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c</migrationPath>
LoadDate=20180629/identity/2018/06/29/v1/federated_identity_mapping/part-05983.gz


ABORT  # curl --insecure -X PUT https://localhost:8084/plugins/migrator/f836e5ad-4ef6-11ea-a818-000d3aa4136c/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20180629/identity/2018/06/29/v1/federated_identity_mapping/part-05983.gz&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=10000&pollTimer=10&dateAfterWhichToMigrate=0"

=============================================================================================
aborted in g1s1
running in g1s2

 /data/published/Marketing/Campaign/FormationCustomerMicrosegmentWeeklyRestricted/ver=01/
<migrationId>fe320ded-4e1e-11ea-b1cc-000d3aa50bab</migrationId>
<migrationPath>/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab</migrationPath>
<migrationEdge>PublishedDate=2018-10-08/part-06637-fda98bf7-4ac7-4225-9e14-682dea0d3ad4.c000.snappy.parquet

ABORT  # curl --insecure -X PUT https://localhost:8084/plugins/migrator/fe320ded-4e1e-11ea-b1cc-000d3aa50bab/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=PublishedDate=2018-10-08/part-06637-fda98bf7-4ac7-4225-9e14-682dea0d3ad4.c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"


Running on g1s1
Aborted in g1s2
<migrationId>8f70c7ae-4e04-11ea-9aa3-000d3aa4136c</migrationId>
<migrationPath>/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c</migrationPath>
   small /data/raw/Marketing/AdActivity/Neustar/ver=01/
<migrationEdge>LoadDate=20180620/events/2018/06/19/v1/collected_attributes/12421/25752/2018_06/part-12364.gz

ABORT  # curl --insecure -X PUT https://localhost:8084/plugins/migrator/8f70c7ae-4e04-11ea-9aa3-000d3aa4136c/abort
RELAUNCH  # curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20180620/events/2018/06/19/v1/collected_attributes/12421/25752/2018_06/part-12364.gz&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=10000&pollTimer=10&dateAfterWhichToMigrate=0"






   /WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab
    LoadDate=20191217/events/2019/12/16/collected_attributes/278/12894/2019_12/part-00073-tid-1156411112919145184-c9552140-8864-4989-9763-4cec48f96c08-7546-1-c000.snappy.parquet

     /WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab
      PublishedDate=2018-06-04/part-02515-216c7740-c18d-415d-81c1-ae69c68cc495.c000.snappy.parquet

curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20191217/events/2019/12/16/collected_attributes/278/12894/2019_12/part-00073-tid-1156411112919145184-c9552140-8864-4989-9763-4cec48f96c08-7546-1-c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"

curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20191217/events/2019/12/16/collected_attributes/278/12894/2019_12/part-00073-tid-1156411112919145184-c9552140-8864-4989-9763-4cec48f96c08-7546-1-c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"



BIG - /data/raw/Marketing/AdActivity/Neustar/ver=02/
/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab
<migrationId>48988fde-4d58-11ea-b4b7-000d3aa50bab</migrationId>
#!/bin/bash

curl --insecure -X PUT https://localhost:8084/plugins/migrator/48988fde-4d58-11ea-b4b7-000d3aa50bab/abort
curl --insecure -X DELETE https://localhost:8084/plugins/migrator/48988fde-4d58-11ea-b4b7-000d3aa50bab/delete

curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-fb5496ae-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20191212/events/2019/12/11/collected_attributes/11323/24675/2019_12/part-00106-tid-3001716584733594648-9a69430a-9b28-47f8-b83a-27ef1d92b8c7-4789-1-c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"



BIG
/data/published/Marketing/Campaign/FormationCustomerMicrosegmentWeeklyRestricted/ver=01/
/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab
    <migrationId>c8980257-4d57-11ea-b4b7-000d3aa50bab</migrationId>
    <migrationEdge>/WD-VIRTUAL-fb5496ae-4aa7-9047-000d3aa50bab/LoadDate=20191212/events/2019/12/11/collected_attributes/11323/24675/2019_12/part-00106-tid-3001716584733594648-9a69430a-9b28-47f8-b83a-27ef1d92b8c7-4789-1-c000.snappy.parquet</migrationEdge>

curl --insecure -X PUT https://localhost:8084/plugins/migrator/c8980257-4d57-11ea-b4b7-000d3aa50bab/abort
curl --insecure -X DELETE https://localhost:8084/plugins/migrator/c8980257-4d57-11ea-b4b7-000d3aa50bab/delete


<migrationPath>/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab</migrationPath>
PublishedDate=2018-05-14/part-00817-0208ef83-7807-414b-9d24-dfb6d547d221.c000.snappy.parquet
/data/published/Marketing/Campaign/FormationCustomerMicrosegmentWeeklyRestricted/ver=01/

curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=PublishedDate=2018-05-14/part-00817-0208ef83-7807-414b-9d24-dfb6d547d221.c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"


#!/bin/bash
curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-f7cc3395-4aa7-11ea-9047-000d3aa50bab&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20191212/events/2019/12/11/collected_attributes/11323/24675/2019_12/part-00106-tid-3001716584733594648-9a69430a-9b28-47f8-b83a-27ef1d92b8c7-4789-1-c000.snappy.parquet&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"




# ============= NOT NOW =========================================
SMALL
/data/raw/Marketing/AdActivity/Neustar/ver=01/
/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c
ABORTED at LoadDate=20180611/events/2018/06/08/v1/collected_attributes/278/12894/2018_06/part-14551.gz

#!/bin/bash
curl --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-33e5875a-4c4b-11ea-9a5d-000d3aa4136c&donor=zone-central&beneficiary=zoneG2-central&startPath=LoadDate=20180611/events/2018/06/08/v1/collected_attributes/278/12894/2018_06/part-14551.gz&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=1000&pollTimer=10&dateAfterWhichToMigrate=0"