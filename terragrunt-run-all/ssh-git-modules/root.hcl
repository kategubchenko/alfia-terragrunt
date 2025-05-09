generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "us-west-2"
}
EOF
}


remote_state {
  backend = "s3"
  config = {
    bucket         = "alfiia-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    // dynamodb_table = "terraform-locks"
  }
}

# Configure root level variables that all environments can inherit
locals {
}
