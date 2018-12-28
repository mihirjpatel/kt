#!/bin/bash

set -e

cd ~/
DOWNLOAD_FILE_NAME=atlassian-confluence-6.11.2-x64.bin
sudo wget https://www.atlassian.com/software/confluence/downloads/binary/${DOWNLOAD_FILE_NAME}
sudo chmod a+x ${DOWNLOAD_FILE_NAME}
sudo ./${DOWNLOAD_FILE_NAME}  -q -varfile ./confluence-configuration-files/response.varfile