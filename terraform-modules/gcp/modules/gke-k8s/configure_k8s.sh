#!/bin/bash

set -eu

# Save certificates
echo "$ISTIO_INGRESS_GATEWAY_CERT_PRIVATE_KEY" > artnet.key
echo "$ISTIO_INGRESS_GATEWAY_CERT" > artnet.pem

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gcloud --quiet config set project "$GOOGLE_PROJECT_ID"
gcloud --quiet config set compute/zone "$GOOGLE_COMPUTE_ZONE"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$GOOGLE_COMPUTE_ZONE" --project "$GOOGLE_PROJECT_ID"

SERVICE_ACCOUNT_INSTALLED=$(kubectl get serviceaccount -n kube-system | grep -q tiller || echo "false")
if [ "$SERVICE_ACCOUNT_INSTALLED" = "false" ]; then
	# Create a service account "Tiller" in Kubernetes that is a cluster admin
	kubectl create -f "$SCRIPT_DIR/helm-service-account.yaml"
fi

# Install Tiller Kubernetes as the "Tiller" service account
helm init --service-account tiller

# Wait for Tiller to be available
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system

# Install the latest Istio
ISTIO_TMP_DIR=$(mktemp -d)
cd "$ISTIO_TMP_DIR"
curl -L https://git.io/getLatestIstio | sh -
ISTIO_PATH="$ISTIO_TMP_DIR/$(ls)"
cd -

# Using NodePort instead of LoadBalancer, for easy port forwarding and integration testing
helm install "$ISTIO_PATH/install/kubernetes/helm/istio" \
    --name istio \
    --namespace istio-system \
    --set ingress.service.type="$INGRESS_SERVICE_TYPE" \
    --set gateways.istio-ingressgateway.type="$INGRESS_SERVICE_TYPE" \
    --set tracing.service.type="$SERVICE_TYPE" \
    --set grafana.enabled="true" \
    --set tracing.enabled="true" \
    --set servicegraph.enabled="true"

# Get names of all Istio deployments
DEPLOYMENT_NAMES=$(kubectl get deployment -o=json --namespace istio-system | jq ".items[].metadata.name")

# Wait for all Istio services
while read -r line; do
    echo "Checking deployment of $line"
    kubectl rollout status -w "deployment/$line" --namespace=istio-system
done <"$DEPLOYMENT_NAMES"

# Labelling namespace default for sidecar injection
kubectl label namespace default istio-injection=enabled

# Showing all namespaces and the sidecar injection status
kubectl get namespace -L istio-injection

# delete secret if exists
kubectl delete secret artnetdev || true
kubectl delete secret database-connstr || true

# create secret for docker registry
kubectl create secret docker-registry \
	artnetdev \
	--docker-server "$DOCKER_REGISTRY" \
	--docker-email "$DOCKER_USER_RO" \
	--docker-username "$DOCKER_USER_RO" \
	--docker-password "$DOCKER_PASSWORD_RO"

# create secret for database connection
kubectl create secret generic \
	database-connstr --from-literal=connStr="${GALLERY_SQL_CONSTR}"

# save certificate secrets
kubectl create -n istio-system secret \
    tls istio-ingressgateway-certs \
    --key "artnet.key" \
    --cert "artnet.pem"
