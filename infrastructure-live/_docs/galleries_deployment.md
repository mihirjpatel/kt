# Galleries Deployment

## Pre-requisites

- Windows, Mac or Linux machine
- [Azure CLI] installed
- Docker installed
- Permissions to ‘Azure Development’ subscription, specifically to the `artnetdev.azurecr.io` Azure Container Registry

## Steps

### Preparation

Pull the deployment Docker image to your local machine (which tests your setup and that you have access to the Azure container registry). Open Terminal or PowerShell Prompt and run:

    az login
    az acr login --name artnetdev
    docker pull artnetdev.azurecr.io/deploy

Create a working directory, create a secrets subdirectory in it and copy secrets from 1 Password

    cd ~
    mkdir secrets

Save the following secrets into `~/secrets`

- `gcp.env`
- `k8s.env`
- `sonicwall.env`
- `terraform-admin.json` (for dev environment)
- `p-tf-svc-acct.json` (for prod environment)

Create a backup of the SonicWall configuration (this is a manual operation)

Start the container

    cd ~/automation-adhoc/gcp/galleries-deployment/
    docker run -it -v ~/secrets:/home/cicd/secrets artnetdev.azurecr.io/deploy

> From this point on, you are running commands in a Docker container!

Clone the repositories (into the container)

    cd ~
    git clone https://github.com/artnetworldwide/automation-adhoc.git
    git checkout v2018-08-22
    git clone https://github.com/artnetworldwide/infrastructure-live
    git checkout v2018-08-22 
    git clone https://github.com/artnetworldwide/terraform-modules.git
    git checkout v3.0.0

### Configure SonicWall

Load configuration values required to run the SonicWall configuration script into shell environment and navigate to the folder containing the SonicWall configuration scripts:

    source ~/secrets/sonicwall.env
    cd ~/automation-adhoc/gcp/sonicwall-vpn-tunnel

SonicWall configuration scripts currently don’t handle the warning saying the authenticity of SonicWall host can’t be established, so we need to connect to SonicWall manually for the first time:

    ssh -oKexAlgorithms=diffie-hellman-group1-sha1 $SONICWALL_HOST

If you see the message that looks like below

    The authenticity of host '192.168.1.1 (192.168.1.1)' can't be established.
    RSA key fingerprint is SHA256:+CN361jx1SmZdVYbuogWqhtv90avZHWpz0qy8Q0d79Y.
    Are you sure you want to continue connecting (yes/no)?

respond `yes` and then press `Crtl-C`.

Test the authentication credentials. The following is a read-only script that displays (a subset) of the SonicWall device configuration that is relevant to the configuration changes being implemented.

    ./get_configuration

Save the “before” configuration:

    ./get_configuration > config_0.txt

Run the configuration script:

    ./configure_vpc

> This script is safe to run multiple times

Save the “after” configuration:

    ./get_configuration > config_1.txt

If you need to rollback, run the following:

    ./unconfigure_vpc
    ./get_configuration > config_2.txt

### Create the GCP projects with the DNS zone, VPC and VPN tunnel, and the K8s cluster

Load the secrets:

    cd ~
    source ~/secrets/gcp.env
    source ~/secrets/k8s.env

Set the environment. Run ONE of the following

    export ENV=DEV (for dev environment)
    export ENV=PRD (for prod environment)

#### Create the shared-core project (which has the DNS zone)

    cd ~/infrastructure-live/gcp/$ENV/_global/shared-core
    terragrunt apply --terragrunt-source ~/terraform-modules/gcp/modules/shared-core

#### Create the VPC

    cd ~/infrastructure-live/gcp/$ENV/green/shared-vpc
    terragrunt apply --terragrunt-source ~/terraform-modules/gcp/modules/shared-vpc

Using the GCP console, verify the VPN tunnel and Cloud Router and up and running.

#### Create the Kubernetes cluster

    cd ~/infrastructure-live/gcp/$ENV/green/gke-k8s-1/
    terragrunt apply --terragrunt-source ~/terraform-modules/gcp/modules/gke-k8s

#### Configure the K8s cluster

Replace the value of GOOGLE_PROJECT_ID with the desired unique id of the Google project in `~/secrets/k8s.env`.

Reload the secret file:

    cd ~
    source ~/secrets/k8s.env

Configure the cluster:

    ~/automation-adhoc/gcp/galleries-deployment/configure_k8s.sh

### Install applications

Check the versions of applications/services being deploued variables values in `~/automation-adhoc/gcp/galleries-deployment/deploy_galleries.sh` and make adjustments to the version of helm charts if needed.

Run

    ~/automation-adhoc/gcp/galleries-deployment/deploy_galleries.sh

[azure cli]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
