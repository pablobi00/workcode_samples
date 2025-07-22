import boto3 
import os
import random
import time

s3 = boto3.client('s3')

TARGETDIRECTORY = 'source_data'
BUCKET = 'pablob-002a'
SOURCE_FILE = './source_data'
# FILE_SIZE = 2 * (1024 ** 2)

def create_source_file():
    """Create a file with random data"""
with open(SOURCE_FILE, 'wb') as fout:
    fout.write(os.urandom(int(2 * (1024 ** 2))) )

def upload_file (target_file_name):
    with open(SOURCE_FILE, "rb") as f:
        s3.upload_fileobj (f,BUCKET,TARGETDIRECTORY+'/'+target_file_name)


def main():
    create_source_file ()
    total_files = 50 # total files to write
    start_file = 51
    for i in range(start_file,start_file+total_files):
        file_number = str(i+1).zfill(3)  # Format the file numbering with leading zeros
        file_name = f"random_file_{file_number}.bin"
        file_name = TARGETDIRECTORY+file_name 
        upload_file(file_name)
                # Report on each 5th file being uploaded
        if (i + 1) % 5 == 0:
            print(f"Uploaded {file_name} to {BUCKET}")

        # For the first 50 files, upload without pausing
        # For the remaining files, pause for 15 seconds after each upload

        if i >= 50:
            time.sleep(5)

if __name__ == "__main__":
    main()