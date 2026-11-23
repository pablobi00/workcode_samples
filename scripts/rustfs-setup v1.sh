#!/usr/bin/env bash

# DISCLAIMER - This code is for test purposes only - DO NOT use in production.
#
# rustfs-setup v1.sh - Lab setup for RustFS (S3-compatible) on Ubuntu
#   - Installs Docker
#   - Runs RustFS in a container (S3 API + web console)
#   - Installs AWS CLI v2 (official installer)

sudo apt update && sudo apt install -y docker.io
sudo mkdir -p /opt/rustfs/data && sudo chown -R 10001:10001 /opt/rustfs/data

sudo docker run -d --name rustfs --restart unless-stopped \
  -p 9000:9000 -p 9001:9001 \
  -v /opt/rustfs/data:/data \
  -e RUSTFS_ACCESS_KEY=labadmin \
  -e RUSTFS_SECRET_KEY='ChangeMe-Lab123!' \
  -e RUSTFS_CONSOLE_ENABLE=true \
  rustfs/rustfs:latest

sudo apt install -y unzip curl
curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install --update
aws --version

aws configure --profile rustfs
# AWS Access Key ID:     labadmin
# AWS Secret Access Key: ChangeMe-Lab123!
# Default region name:   us-east-1
# Default output format: json

touch file_a1.txt
aws --profile rustfs --endpoint-url http://localhost:9000 s3 mb s3://bucket-a
aws --profile rustfs --endpoint-url http://localhost:9000 s3 cp s3://bucket-a/file-a1.txt
aws --profile rustfs --endpoint-url http://localhost:9000 s3 ls s3://bucket-a/

printf '\n=========\n[END]\n\n'