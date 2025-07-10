generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"

  # Using Terragrunt's `get_parent_terragrunt_dir` to dynamically reference parent variables
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "kate-terraform-state-bucket-for-terragrunt"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
   // dynamodb_table = "terraform-locks"
  }
}
EOF
}
