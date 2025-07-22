#!/usr/bin/python3

import boto3 # In my MAC - pipx install boto3 --include-deps
import os
import random
import time
from colorama import Fore # for MAC also - pip3 install colorama --break-system-packages

cBlue = (Fore.CYAN)
cGreen = (Fore.GREEN)
cReset = (Fore.RESET)

s3 = boto3.client('s3')

TARGET_DIRECTORY = 'source_data'    # destination directory where data will be copied
BUCKET = 'pablob-002e'              # using same bucket for all
SOURCE_FILE = 'source_file'         # name of generated source file
SOURCE_DIRECTORY = 'common_data'    # transit directory in s3
FILE_SIZE = int(1 * (1024 ** 2)) # 1024 ** 2 = MB // 1024 ** 3 = GB

total_files = 1000 # total files to write
start_file = 0    # Initial number is start_file + 1
last_file = start_file + total_files

def create_source_file():
    """Create a file with random data"""
    print (cBlue+'Creating local {}...'.format(SOURCE_FILE)+cReset)
    with open(SOURCE_FILE, 'wb') as fout:
        fout.write(os.urandom(FILE_SIZE) )

def upload_file ():
    print (cGreen+'Uploading {} to {}/{}'.format (SOURCE_FILE,BUCKET,SOURCE_DIRECTORY)+cReset) 
    with open(SOURCE_FILE, "rb") as f:
        s3.upload_fileobj (f,BUCKET,SOURCE_DIRECTORY+'/'+SOURCE_FILE)

def copy_file (target_file_name):
    destination_key = TARGET_DIRECTORY+'/'+target_file_name
    copy_source = {'Bucket': BUCKET, 'Key': SOURCE_DIRECTORY+'/'+SOURCE_FILE}
    s3.copy_object(CopySource=copy_source, Bucket=BUCKET, Key=destination_key)
  

def main():
    create_source_file ()
    upload_file ()

    for i in range (start_file,last_file):
        file_number = str(i+1).zfill(3)  # Format the file numbering with leading zeros
        file_name = f"random_file_{file_number}.bin"
        copy_file (file_name)

        # Report on each 5th file being uploaded
        if (i + 1) % 5 == 0:
            print(f"Copied {file_name} to {BUCKET}/{TARGET_DIRECTORY}")

        # For the first 50 files, upload without pausing
        # For the remaining files, pause for 15 seconds after each upload

        # if i >= 50:
        #    time.sleep(5)


if __name__ == "__main__":
    main()

print (cBlue+'\n=====\n[EOF]\n=====\n'+cReset)
