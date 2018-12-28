#!/bin/bash

set -e

cd ~/
DOWNLOAD_FILE_NAME=atlassian-jira-software-7.12.1-x64.bin
sudo apt-get update
sudo wget https://www.atlassian.com/software/jira/downloads/binary/${DOWNLOAD_FILE_NAME}
sudo chmod a+x ${DOWNLOAD_FILE_NAME}
sudo ./${DOWNLOAD_FILE_NAME} -q -varfile jira-configuration-files/response.varfile
sudo cp jira-configuration-files/server.xml /opt/atlassian/jira/conf/
sudo cp jira-configuration-files/web.xml /opt/atlassian/jira/conf/
sudo cp jira-configuration-files/certificate.pfx /opt/atlassian/jira/conf/