Prerequisites:
You will need Terraform and AWS installed on your machine/VM
Create S3 bucket and Dynamo DB table in AWS to store the terraform state information.

Steps:
1. Create an S3 bucket for Terraform. BUCKET NAME MUST BE UNIQUE.
aws s3api create-bucket --bucket km-terraform-state-112820251232 --region us-east-1
 
2.	Enable versioning on the bucket
aws s3api put-bucket-versioning  --bucket km-terraform-state-112820251232  --versioning-configuration Status=Enabled
 
3. Block Public Access
aws s3api put-public-access-block \
  --bucket km-terraform-state-112820251232 \
  --public-access-block-configuration '{
      "BlockPublicAcls": true,
      "IgnorePublicAcls": true,
      "BlockPublicPolicy": true,
      "RestrictPublicBuckets": true
  }'

4.	Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name km-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

5. Make changes in the environment variable(envs/tfvars files) to point to the correct credentials.

This is VPC module for Kube Matrix (km).

Creates:
- VPC with provided CIDR
- public & private subnets across AZs
- IGW, NAT Gateway(s)
- route tables and associations
- VPC endpoints for S3 and SSM
- basic security groups (bastion, eks nodes, db)
Naming & tags follow project conventions in AWS Infrastructure Standards Guide.

Make changes to the tfvars files to input your personal credentials

