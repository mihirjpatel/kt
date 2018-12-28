# Jira and Confluence Compute Engines

## Prerequisite

1. Static External IP must be created in GCP and defined in the terragrunt file
2. Presisted Disk for Data Directory must exist (Take copy of backup of production and restore it to your project)
3. Postgresql instance must exist - Restore from a production backup (make sure the dbconfig file in the data directory is pointing to the correct db)
4. An Image must be prepared in advance using Packer for Jira and Confluence.

### Steps

1. Modify the terragrunt variables file
2. cd to the appropriate folder (jira or confluence)
2. Run "terragrunt plan-all"
3. Run "terragrunt apply-all"
