#!/bin/bash

set -e

# if [ "$1" = "" ]; then
#     echo "Must specify AWS_EFS_ID as parameter 1"
#     exit 1
# fi

AWS_EFS_ID="fs-83a535cb"

sudo sh -c "echo \"$AWS_EFS_ID:/ /efs efs defaults,_netdev 0 0\" >> /etc/fstab"
