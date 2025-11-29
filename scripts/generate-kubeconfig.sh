#!/bin/bash
# Script to generate kubeconfig for a developer for an existing EKS cluster

# -------------------------
# Configurable parameters
# -------------------------
CLUSTER_NAME=${1:-"<your-cluster-name>"}     # Default: replace with your cluster name
REGION=${2:-"us-east-1"}                   # Default: N. Virginia
KUBECONFIG_FILE=${3:-"$HOME/.kube/config"}  # Default kubeconfig location

# -------------------------
# Prerequisites check
# -------------------------
command -v aws >/dev/null 2>&1 || { echo >&2 "AWS CLI not installed. Exiting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl not installed. Exiting."; exit 1; }

# -------------------------
# Generate kubeconfig
# -------------------------
echo "Generating kubeconfig for EKS cluster '$CLUSTER_NAME' in region '$REGION'..."
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME --kubeconfig $KUBECONFIG_FILE

# -------------------------
# Test connection
# -------------------------
echo "Testing connection..."
kubectl get nodes

if [ $? -eq 0 ]; then
    echo "✅ Kubeconfig setup successful. You can now run kubectl commands."
else
    echo "❌ Failed to connect. Check your AWS credentials and cluster permissions."
fi
