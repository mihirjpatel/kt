#!/bin/bash

set -e

# if [ "$1" = "" ]; then
#     echo "Must specify AWS_EFS_ID as parameter 1"
#     exit 1
# fi


DATA_DIR="/atlassian"
sudo mkdir $DATA_DIR

echo UUID=`sudo blkid -s UUID -o value /dev/sdb` $DATA_DIR ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab