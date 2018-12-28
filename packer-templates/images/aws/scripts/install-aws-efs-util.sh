#!/bin/bash

set -e

git clone https://github.com/aws/efs-utils
cd /home/ubuntu/efs-utils
make deb
sudo apt-get install -y ./build/amazon-efs-utils*deb
