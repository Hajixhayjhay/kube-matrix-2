#!/bin/bash
set -e

ENV=${1:-dev}

echo "🚀 Initializing Terraform for environment: $ENV"

terraform init -upgrade

# Create workspace if not exists
if ! terraform workspace list | grep -q "$ENV"; then
  echo "🔧 Creating workspace: $ENV"
  terraform workspace new "$ENV"
fi

terraform workspace select "$ENV"

echo "✅ Terraform initialized and workspace selected: $ENV"
