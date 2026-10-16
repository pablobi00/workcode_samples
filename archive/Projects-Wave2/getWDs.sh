#!/usr/bin/env bash
NODE=$1
echo "Writers list for $NODE" > writers-$NODE.txt

for i in 8058b25f-5429-11ea-885d-000d3aa50bab 81108fc2-5429-11ea-885d-000d3aa50bab 217f28f6-542b-11ea-885d-000d3aa50bab 33f03ae9-542b-11ea-885d-000d3aa50bab 333faf80-542b-11ea-885d-000d3aa50bab 328deb92-542b-11ea-885d-000d3aa50bab 31e37aae-542b-11ea-885d-000d3aa50bab 31362496-542b-11ea-885d-000d3aa50bab 3088f48c-542b-11ea-885d-000d3aa50bab 2fdada1e-542b-11ea-885d-000d3aa50bab 2f2e4657-542b-11ea-885d-000d3aa50bab 2e7dbaec-542b-11ea-885d-000d3aa50bab 2dcd086e-542b-11ea-885d-000d3aa50bab 2d1fff77-542b-11ea-885d-000d3aa50bab 224d4e79-542b-11ea-885d-000d3aa50bab 448c3ef4-542b-11ea-885d-000d3aa50bab 43d91b74-542b-11ea-885d-000d3aa50bab 432d4aff-542b-11ea-885d-000d3aa50bab 42778f75-542b-11ea-885d-000d3aa50bab 41c94df8-542b-11ea-885d-000d3aa50bab 411c44fc-542b-11ea-885d-000d3aa50bab 406b4461-542b-11ea-885d-000d3aa50bab 3fc05e4a-542b-11ea-885d-000d3aa50bab 3efcc10d-542b-11ea-885d-000d3aa50bab 3e4ea6a3-542b-11ea-885d-000d3aa50bab 3d97d9a5-542b-11ea-885d-000d3aa50bab 3ceca573-542b-11ea-885d-000d3aa50bab 3c395ae6-542b-11ea-885d-000d3aa50bab 3b8d8a73-542b-11ea-885d-000d3aa50bab 3acaaf83-542b-11ea-885d-000d3aa50bab 3a1c46f4-542b-11ea-885d-000d3aa50bab 396b6d6c-542b-11ea-885d-000d3aa50bab 38b93454-542b-11ea-885d-000d3aa50bab 380b901b-542b-11ea-885d-000d3aa50bab 375ab695-542b-11ea-885d-000d3aa50bab 36adfbbe-542b-11ea-885d-000d3aa50bab 35fcacff-542b-11ea-885d-000d3aa50bab 354f55eb-542b-11ea-885d-000d3aa50bab 34a1b0b0-542b-11ea-885d-000d3aa50bab
do
  echo "Path = $i" >> writers.txt
  curl --insecure https://localhost:8084/fusion/fs?path=/WD-VIRTUAL-$i | xmllint -format - | grep "<name>" >> writers.txt
  curl --insecure https://localhost:8084/fusion/fs?path=/WD-VIRTUAL-$i | xmllint -format - | grep nodeId >> writers.txt
done

printf '\n=====\n[EOL]\n'
