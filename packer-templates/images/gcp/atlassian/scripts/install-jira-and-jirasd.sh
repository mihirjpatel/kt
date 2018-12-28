#!/bin/bash

set -e

JIRA_HOME="/atlassianbucket/jira"
JIRA_INSTALL="/opt/atlassian/jira"
APP_VERSION="3.15.0"
JIRA_VERSION="7.12.0"
JIRA_INSTALLATION_BINARY="https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.12.0.tar.gz"
JIRASD_INSTALLATION_BINARY="https://www.atlassian.com/software/jira/downloads/binary/atlassian-servicedesk-3.15.0.tar.gz"



sudo mkdir -p                "${JIRA_HOME}"
sudo mkdir -p                "${JIRA_HOME}/caches/indexes"
sudo mkdir -p                "${JIRA_HOME}/plugins/installed-plugins"
sudo chmod -R 700            "${JIRA_HOME}"
sudo chown -R daemon:daemon  "${JIRA_HOME}"
sudo mkdir -p                "${JIRA_INSTALL}/conf/Catalina"
sudo curl -Ls                "${JIRA_INSTALLATION_BINARY}" | sudo tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner
sudo curl -Ls                "${JIRASD_INSTALLATION_BINARY}" | sudo tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner
sudo rm -f                   "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar"
sudo curl -Ls                "https://jdbc.postgresql.org/download/postgresql-42.2.1.jar" -o "${JIRA_INSTALL}/lib/postgresql-42.2.1.jar"
sudo chmod -R 700            "${JIRA_INSTALL}/conf"
sudo chmod -R 700            "${JIRA_INSTALL}/logs"
sudo chmod -R 700            "${JIRA_INSTALL}/temp"
sudo chmod -R 700            "${JIRA_INSTALL}/work"
sudo chown -R daemon:daemon  "${JIRA_INSTALL}/conf"
sudo chown -R daemon:daemon  "${JIRA_INSTALL}/logs"
sudo chown -R daemon:daemon  "${JIRA_INSTALL}/temp"
sudo chown -R daemon:daemon  "${JIRA_INSTALL}/work"
sudo sed --in-place          "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" 
sudo sed -i                  s,"jira.home =","jira.home = $JIRA_HOME",g "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"
sudo touch -d "@0"           "${JIRA_INSTALL}/conf/server.xml"
