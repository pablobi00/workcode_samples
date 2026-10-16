import boto3 
import os
import random
import time

def generate_random_size (size_in_mb):
    """Generate random size in bytes"""
    file_size = random.randint(1, 3)  # Random file size between 1MB and 3MB
    size_in_bytes = size_in_mb * 1024 * 1024  # Convert MB to Bytes
    return os.urandom(generate_random_size(file_size))

def create_source_file(file_name, size_in_bytes):
    """Create a file with random data"""
    with open(SOURCE_FILE, 'wb') as fout:
        fout.write(os.urandom(size_in_bytes))

def upload_file (target_file_name):
    s3.meta.client.upload_file(Filename = SOURCE_FILE, Bucket = BUCKET, Key = TARGETDIRECTORY/target_file_name)

def main():
    total_files = 10 # total files to write
    for i in range(total_files):
        file_size = random.randint(1, 3)  # Random file size between 1MB and 3MB
        file_number = str(i+1).zfill(3)  # Format the file numbering with leading zeros
        file_name = f"random_file_{file_number}.bin"
        data_size = generate_random_size(file_size)
#         create_source_file (file_name,data_size)
        file_name = TARGETDIRECTORY+file_name 
#         upload_file(file_name)
        print (file_name,file_size,file_number)
        # Report on each 5th file being uploaded
        if (i + 1) % 5 == 0:
            print(f"Uploaded {file_name} of size {file_size}MB to Azure ADLS Gen2")

        # For the first 50 files, upload without pausing
        # For the remaining files, pause for 15 seconds after each upload
        if i >= 50:
            time.sleep(5)

if __name__ == "__main__":
    main()