#!/bin/bash
set -e

ENV=${1:-dev}

echo "📘 Planning Terraform changes for environment: $ENV"

terraform workspace select "$ENV"

terraform plan \
  -var-file="envs/$ENV.tfvars" \
  -out="tfplan-$ENV"

echo "✅ Plan created: tfplan-$ENV"
