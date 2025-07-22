from azure.storage.blob import BlobServiceClient
import crc32c
import hashlib

# Azure Storage details

storage_a = '<storage_account>
storage_account_url = "https://<storage_account>.blob.core.windows.net"
container_name = "gen2-001"
blob_name = "data/data-a/data50001.csv"
sas_token = "<ssas token>"  # Use if needed

# Connect to Azure Blob Storage
blob_service_client = BlobServiceClient(account_url=storage_account_url, credential=sas_token)
blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

# Initialize hash objects
crc32c_list = []
chunk_size = 512  # Process in 512-byte blocks

# Open the stream
stream = blob_client.download_blob()
reader = stream.content_as_bytes()  # Load into a bytes-like object

# Process file in 512-byte chunks
for i in range(0, len(reader), chunk_size):
    chunk = reader[i : i + chunk_size]
    crc32c_hash = crc32c.crc32c(chunk)
    crc32c_list.append(crc32c_hash.to_bytes(4, "big"))  # Store as bytes

# Compute MD5 of CRC32C values
crc32c_combined = b"".join(crc32c_list)
md5_of_crc32c = hashlib.md5(crc32c_combined).digest()

# Compute MD5-of-0MD5-of-512CRC32C
empty_md5 = hashlib.md5(b"").digest()
final_md5 = hashlib.md5(empty_md5 + md5_of_crc32c).hexdigest()

# Print the final checksum
print(f"Streaming MD5-of-0MD5-of-512CRC32C: {final_md5}")