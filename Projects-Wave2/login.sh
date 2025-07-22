#!/bin/sh

# use - modify to use variables ./login.sh admin -----

curl -v \
 --header "Accept: application/json, text/plain, */*" \
 --header "Content-Type: application/json;charset=UTF-8" \
 --data '{"username":"admin","password":"-----"}' \
 --insecure \
 https://localhost:8443/api/authenticate/login

