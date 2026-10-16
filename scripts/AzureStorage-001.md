az storage blob copy start \
    --account-name <storage_account> \
    --auth-mode login \
    --source-container gen2-west2-01 \
    --source-blob /folder-c \
    --destination-container gen2-west2-01 \
    --destination-blob /folder-c \
    --source-path /folder-c/folder-c1 \
    --destination-path /folder-c/folder-c20
    
# --source-path /folder-c/folder-1c

az storage blob copy start \
    --account-name <storage_account> \
    --auth-mode login \
    --destination-container gen2-west2-01 \
    --destination-blob /folder-c/folder-c20 \
    --source-uri https://<storage_account>.blob.core.windows.net/gen2-west2-01/folder-c/folder-c1

azcopy   https://<storage_account>.blob.core.windows.net/gen2-west2-01/folder-c/folder-1c  https://<storage_account>.blob.core.windows.net/gen2-west2-01/folder-c/folder-2c