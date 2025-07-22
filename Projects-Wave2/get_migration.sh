#!/bin/bash
curl --insecure https://localhost:8084/plugins/migrator/$1 | xmllint --format -

