terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "remote" {
    hostname     = "boop.release-branches.testenv.scalr.dev"
    organization = "Environment-A"
    workspaces {
      name = "cli"
    }
  }
}

locals {
  config = yamldecode(file("${path.module}/config.yaml"))
  regions = local.config[var.environment].regions
}

provider "aws" {
  for_each = local.regions
  region   = each.key
  alias    = "by_region"
}

resource "aws_s3_bucket" "alfiias_bucket" {
  for_each = local.regions
  provider = aws.by_region[each.key]
  bucket = "alfiia-test-s3-${var.environment}-${each.key}"
  tags = {
    Environment = var.environment
    Region      = each.key
  }
}
