#!/usr/bin/python3
import boto3 
import json 
import requests


# Initialize the S3 client
s3 = boto3.client('s3')

'''
# List all S3 buckets
response = s3.list_buckets()


# Print the bucket names
for bucket in response['Buckets']:
    print(f'Bucket Name: {bucket["Name"]}')
'''

# Access a specific bucket
bucket_name = 'pablob-001a'

# List objects in the bucket
objects = s3.list_objects(Bucket=bucket_name)

# Print object keys
for obj in objects.get('Contents', []):
    print(f'Object Key: {obj["Key"]}')

'''
# Upload a file to the bucket
file_path = 'path/to/your/file.txt'
s3.upload_file(file_path, bucket_name, 'remote-file-name.txt')

# Download a file from the bucket
s3.download_file(bucket_name, 'remote-file-name.txt', 'local-file-name.txt''

'''
