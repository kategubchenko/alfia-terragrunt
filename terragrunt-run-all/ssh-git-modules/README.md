# Infrastructure Deployment with Terragrunt & SSH-Loaded Modules

This repository uses **Terragrunt** to orchestrate reusable **Terraform modules** sourced via **SSH from GitHub**, and manages remote state in **AWS S3**.

---

### 🔐 Requirements

- [Terragrunt](https://terragrunt.gruntwork.io/)
- [OpenTofu](https://opentofu.org/) or [Terraform](https://terraform.io/)
- Access to GitHub via SSH
- Valid AWS credentials
---

### 📦 What This Deploys

Each module (`module-1`, `module-2`) pulls the following module from GitHub over SSH:

```hcl
terraform {
  source = "git::ssh://git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//modules/asg-alb-service?ref=v0.8.1"
}
```

This module provisions:

- An Auto Scaling Group (ASG)
- An Application Load Balancer (ALB)
- Listener and Target Groups 
- Related EC2 infrastructure

### 📦 Remote State Configuration

Remote state is stored in an S3 bucket. 
Change values in the code to configure connection to your own bucket.

Each module’s state file is automatically namespaced based on folder path using:

```hcl
key = "${path_relative_to_include()}/terraform.tfstate"
```

### 🔧 Provider Configuration
The AWS provider is injected dynamically from root.hcl using Terragrunt’s generate block:

```hcl
generate "provider" {
path      = "provider.tf"
if_exists = "overwrite"
contents  = <<EOF
provider "aws" {
region = var.aws_region
}
EOF
}
```
Note: Currently, aws_region is hardcoded in ``root.hcl``. 🐒
You can replace this with a dynamic input to support multi-region deployments in the future. 
