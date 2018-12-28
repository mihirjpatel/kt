#!/bin/bash

set -e

cd /home/ubuntu
sudo wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.9.0-x64.bin
sudo chmod a+x atlassian-confluence-6.9.0-x64.bin
sudo ./atlassian-confluence-6.9.0-x64.bin -q -varfile ./confluence-configuration-files/response.varfile
