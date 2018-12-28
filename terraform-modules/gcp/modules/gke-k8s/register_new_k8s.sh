#!/bin/bash
# Refreshes deployment processes so that they point to the newly provisioned cluster

set -eu


SHARED_SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../../../shared_scripts && pwd)"
SET_ENV_SCRIPT_PATH="$SHARED_SCRIPTS_DIR/set_circleci_env_variable.py"

# Applications refer to _PROD
if [ "$ENV" == "PRD" ]; then
    ENV="PROD"
fi

# Artnet.Pilot
export GITHUB_REPO=artnet-pilot
"$SET_ENV_SCRIPT_PATH" --key "STATIC_SITE_DEPLOY_GCLOUD_SERVICE_ACCOUNT_$ENV" --value "$STATIC_SITE_SERVICE_ACCOUNT"
"$SET_ENV_SCRIPT_PATH" --key "STATIC_SITE_DEPLOY_GOOGLE_BUCKET_NAME_$ENV" --value "$STATIC_SITE_BUCKET_NAME"
"$SET_ENV_SCRIPT_PATH" --key "STATIC_SITE_DEPLOY_GOOGLE_PROJECT_ID_$ENV" --value "$K8_PROJECT_ID"

# Gallery Profile API
export GITHUB_REPO=gallery-profile-api
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GCLOUD_SERVICE_ACCOUNT_$ENV" --value "$K8_SERVICE_ACCOUNT"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_CLUSTER_NAME_$ENV" --value "$K8_CLUSTER_NAME"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_COMPUTE_ZONE_$ENV" --value "$K8_COMPUTE_ZONE"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_PROJECT_ID_$ENV" --value "$K8_PROJECT_ID"

# Falcon GraphQL server
export GITHUB_REPO=falcon-hatchling-graphql-server
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GCLOUD_SERVICE_ACCOUNT_$ENV" --value "$K8_SERVICE_ACCOUNT"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_CLUSTER_NAME_$ENV" --value "$K8_CLUSTER_NAME"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_COMPUTE_ZONE_$ENV" --value "$K8_COMPUTE_ZONE"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_PROJECT_ID_$ENV" --value "$K8_PROJECT_ID"

# Storage proxy
export GITHUB_REPO=presentation-dotcom-storage-proxy
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GCLOUD_SERVICE_ACCOUNT_$ENV" --value "$K8_SERVICE_ACCOUNT"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_CLUSTER_NAME_$ENV" --value "$K8_CLUSTER_NAME"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_COMPUTE_ZONE_$ENV" --value "$K8_COMPUTE_ZONE"
"$SET_ENV_SCRIPT_PATH" --key "HELM_DEPLOY_GOOGLE_PROJECT_ID_$ENV" --value "$K8_PROJECT_ID"
"$SET_ENV_SCRIPT_PATH" --key "STATIC_RESOURCES_GOOGLE_BUCKET_NAME_$ENV" --value "$STATIC_SITE_BUCKET_NAME"