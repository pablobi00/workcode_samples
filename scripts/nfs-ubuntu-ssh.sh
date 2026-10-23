#!/bin/bash
set -uo pipefail

SERVER="192.168.68.131"
EXPORT="/srv/nfs/share"         # <-- change to shared directory in NFS server
MOUNTPOINT="/mnt/nfs-share"     # <-- change to mount point in client
SSH_USER="pablob"               # <-- change
CLIENTS=(node-a kubernetes-a core-a pea-vulnerability)   # <-- change
SSH_KEY='/Users/pablo.barcenas/Documents/labs-p/keys/pablob_generic'  # <-- change to your private key path

# pea-master-a pea-cd4pe pea-vulnerability pea-scm node-a node-b kubernetes-a core-a

# This block runs on each client
read -r -d '' REMOTE_SCRIPT <<EOF || true
set -e
sudo apt-get update -qq
sudo apt-get install -y -qq nfs-common
sudo mkdir -p $MOUNTPOINT
grep -q "$SERVER:$EXPORT" /etc/fstab || echo "$SERVER:$EXPORT $MOUNTPOINT nfs4 vers=4.2,_netdev,hard,timeo=600,nofail 0 0" | sudo tee -a /etc/fstab >/dev/null
sudo systemctl daemon-reload
sudo mount -a
nfsstat -m | grep -A1 "$MOUNTPOINT"
touch $MOUNTPOINT/hello-from-\$(hostname) && echo "WRITE OK"
EOF

for c in "${CLIENTS[@]}"; do
  echo "=== $c ==="
  if ssh -i "$SSH_KEY" -o ConnectTimeout=5 -o BatchMode=yes "$SSH_USER@$c" "bash -s" <<< "$REMOTE_SCRIPT"; then
    echo ">>> OK: $c"
  else
    echo ">>> FAILED: $c"
  fi
done
