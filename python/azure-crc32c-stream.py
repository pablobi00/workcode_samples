from azure.storage.blob import BlobServiceClient
import crc32c

# Azure Storage details

storage_a = '<storage_account>

storage_account_url = "https://<storage_account>.blob.core.windows.net"
container_name = "gen2-001"
blob_name = "data/data-a/data50001.csv"
sas_token = "<ssas token>"  # Use if needed

# Connect to Blob Storage
blob_service_client = BlobServiceClient(account_url=storage_account_url, credential=sas_token)
blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

# Stream & compute CRC32C
crc32c_hash = 0
stream = blob_client.download_blob()
for chunk in stream.chunks():
    crc32c_hash = crc32c.crc32c(chunk, crc32c_hash)

print(f"CRC32C Checksum: {crc32c_hash:#010x}")