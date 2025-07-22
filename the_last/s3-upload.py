#!/usr/bin/python3
import boto3 

s3 = boto3.client('s3')

# Source and destination bucket names

source_bucket = 'pablob-001a'
destination_bucket = 'pablob-001a'
source_key = 'data-1/file-2-a'

for i in range(500):
    destination_key = 'data/moredata1/file10M-'+str(i) 
    copy_source = {'Bucket': source_bucket, 'Key': source_key}
    s3.copy_object(CopySource=copy_source, Bucket=destination_bucket, Key=destination_key)
