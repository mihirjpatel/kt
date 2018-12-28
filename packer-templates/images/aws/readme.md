# Running Packer with AWS

## Prerequisites

Packer must be Downloaded and installed (Set Environment Variable).
EFS should already be set up with the correct availability zones.

## JIRA

Using Ubuntu AMI from AWS.

1. Start Terminal and go to the aws folder path
2. Open ./variables/variables.json file and set the variables
3. WIP - Open `./scripts/persist-efs-mount.sh` and replace ${ENTER EFS ID} with the EFS ID
4. WIP - Open `./scripts/add-dc-hostname-entry.sh` and replace ${Add DC1 Host File Entry} and ${Add DC2 Host File Entry} with hostfile entries for 2 Domain Controller -- Add/Remove as needed.  (Example: 192.168.1.10 DC1.artnet.com)
5. Run --
```sh
$ packer build -var-file="./variables/variables.json" ./ubuntu16/aws-jira-ami.json
```

This will start the build using ami-a4dc46db AMI.
Once completed a private AMI will be created with the name jira-ami-{{timestamp}}




## CONFLUENCE

Using Ubuntu AMI from AWS.

1. Start Terminal and go to the aws folder path
2. Open ./variables/variables.json file and set the variables
3. WIP - Open ./scripts/presist-efs-mount.sh and replace ${ENTER EFS ID} with the EFS ID
4. WIP - Open ./scripts/add-dc-hostname-entry.sh and replace ${Add DC1 Host File Entry} and ${Add DC2 Host File Entry} with hostfile entries for 2 Domain Controller -- Add/Remove as needed.  (Example: 192.168.1.10 DC1.artnet.com DC1)
5. Run --
```sh
$ packer build -var-file="./variables/variables.json" ./ubuntu16/aws-confluence-ami.json
```
This will start the build using ami-a4dc46db AMI.
Once completed a private AMI will be created with the name confluence-ami-{{timestamp}}# Dillinger
