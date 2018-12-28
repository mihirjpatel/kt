
# atlassian Packer images for GCP 

## Jira Installation ##

> Assumption: You have packer 1.2.5 installed as this is the version which was tested.


> NOTE:
> 1. ./jira-software-and-service-desk/vars.json is the variables json file which contains all of the variables which can be modified.  Current variables settings are where production packer is deployed.
> 2. ./jira-software-and-service-desk/gcp-jira-image.json is the packer template (variables get passed to this template when running the command below)
> 3. To change the jira version of the template, you must go to ./scripts/install-jira.sh and modify the installation package.


#### 1. Copy the certificate.pfx file to ./scripts/jira-configuration-files (can be found in secrets repository) ####
File name must be certificate.pfx as it is referenced in the configuration

#### 2. Edit the ./scripts/jira-configuration-files/server.xml to set password ####
Replace "{EnterKeystorePasswordHere}" to the certificate's password (can be found in secrets repository)

#### 2. Run the following command to create  variable for google credentials path.  This is used by packer to create and manage GCP resources ####
export GOOGLE_APPLICATION_CREDENTIALS="{Enter Path for GOOGLE Credentials (Tested json credential files)}"

#### 3. Go to the path where the template and scripts are located.  The template will not work if you are in a different path. ####
cd /images/gcp/atlassian

#### 4. Validate the packer image: ####
packer validate -var-file="./jira-software-and-service-desk/vars.json" ./jira-software-and-service-desk/gcp-jira-image.json

#### 5. RUN the packer build (Image will be created once the build is completed): ####
packer build -var-file="./jira-software-and-service-desk/vars.json" ./jira-software-and-service-desk/gcp-jira-image.json

