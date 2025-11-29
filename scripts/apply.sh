#!/bin/bash
set -e

ENV=${1:-dev}

echo "🚢 Applying Terraform for environment: $ENV"

terraform workspace select "$ENV"

terraform apply "tfplan-$ENV"

echo "🎉 Apply completed for environment: $ENV"
