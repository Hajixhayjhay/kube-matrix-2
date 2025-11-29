#!/bin/bash
set -e

ENV=${1:-dev}

echo "🔥 Destroying Terraform resources for environment: $ENV"

terraform workspace select "$ENV"

terraform destroy -var-file="envs/$ENV.tfvars"

echo "💀 Destroy completed for environment: $ENV"
