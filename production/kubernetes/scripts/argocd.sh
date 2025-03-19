#!/bin/bash

set -e  # Exit on error

# Main cluster where ArgoCD is installed
MAIN_CLUSTER="maks-pro-centralindia-admin"

# Clusters to add to ArgoCD
CLUSTERS_TO_ADD=("maks-pro-eastus-admin" "maks-pro-ukwest-admin")

# Function to check if ArgoCD namespace exists
namespace_exists() {
    kubectl get namespace argocd &> /dev/null
}

# Function to check if ArgoCD is installed
argocd_installed() {
    kubectl get pods -n argocd | grep argocd-server &> /dev/null
}

echo "Ensuring ArgoCD is installed in $MAIN_CLUSTER..."

# Install ArgoCD if not installed
if namespace_exists; then
    echo "ArgoCD namespace exists. Skipping installation."
else
    echo "ArgoCD not found. Installing ArgoCD..."
    kubectl create namespace argocd
    helm install argocd argo/argo-cd -n argocd
    echo "Waiting for ArgoCD server to be ready..."
    kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
fi

echo "Retrieving ArgoCD initial password..."
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)

echo "Logging in to ArgoCD..."
argocd login --insecure --username admin --password "$ARGOCD_PASSWORD" --grpc-web 127.0.0.1:8081

# Add other clusters
for CLUSTER in "${CLUSTERS_TO_ADD[@]}"; do
    echo "Adding cluster $CLUSTER to ArgoCD..."
    argocd cluster add "$CLUSTER" --yes || echo "Cluster $CLUSTER is already added. Skipping..."
done

echo "ArgoCD setup is complete!"
