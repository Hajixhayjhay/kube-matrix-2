terraform {
  backend "s3" {
    bucket         = "km-terraform-state-28112025"
    key            = "envs/dev/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "km-terraform-locks"
    encrypt        = true
  }
}
