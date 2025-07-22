#!/usr/bin/python3
import os
import random
import time
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient

# Azure Storage account information

# STORAGE_ACCOUNT_NAME = 'your_storage_account_name'
# CONTAINER_NAME = 'your_container_name'
# STORAGE_ACCOUNT_KEY = 'your_shared_key'
# CONNECTION_STRING = f"DefaultEndpointsProtocol=https;AccountName={STORAGE_ACCOUNT_NAME};AccountKey={STORAGE_ACCOUNT_KEY};EndpointSuffix=core.windows.net"


# Initialize the BlobServiceClient
blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

def generate_random_data(size_in_mb):
    """Generate random bytes data of specified size in MB."""
    size_in_bytes = size_in_mb * 1024 * 1024  # Convert MB to Bytes
    return os.urandom(size_in_bytes)

def create_and_upload_file(file_name, data):
    """Create a file with random data and upload it to Azure ADLS."""
    blob_client = container_client.get_blob_client(file_name)
    blob_client.upload_blob(data)

def main():
    total_files = 5
    for i in range(total_files):
        file_size = random.randint(1, 3)  # Random file size between 5MB and 25MB
        file_number = str(i+1).zfill(3)  # Format the file numbering with leading zeros
        file_name = f"random_file_{file_number}.bin"
        data = generate_random_data(file_size)
        file_name = 'more-data/'+file_name 
        create_and_upload_file(file_name, data)
        
        # Report on each 5th file being uploaded
        if (i + 1) % 5 == 0:
            print(f"Uploaded {file_name} of size {file_size}MB to Azure ADLS Gen2")

        # For the first 50 files, upload without pausing
        # For the remaining files, pause for 15 seconds after each upload
        if i >= 3:
            time.sleep(1)

if __name__ == "__main__":
    main()
