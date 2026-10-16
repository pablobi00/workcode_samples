#!/bin/sh
# How to use it --> # login_fusion AdminPassword

curl -v \
 --header "Accept: application/json, text/plain, */*" \
 --header "Content-Type: application/json;charset=UTF-8" \
 --data '{"username":"admin","password":"$1"}' \
 --insecure \
 https://localhost:8443/api/authenticate/login

printf '\n=====[EOL]\n'
