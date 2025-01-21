terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "2.3.0"
    }
  }
}

provider "scalr" {
  //Fill with your hostname and token with corresponded permissions
  hostname = ""
  token    = ""
}

locals {
  account_read_only_users = [
    //Fill list with user emails from corresponded acc
    "",
    "",
    ""
  ]
}

variable "scalr_account_id" {
  description = "The ID of the Scalr account"
  type        = string
  default     = "acc-..." // Enter your acc-id
}

variable "scalr_read_only_role_id" {
  description = "The ID of the Scalr read-only role"
  type        = string
  default     = "role-"
}

#resource "scalr_role" "example-read-only" {
#  name        = "Reader"
#  account_id  = var.scalr_account_id
#  description = "Test with created in config"
#
#  permissions = [
#    "accounts:read",
#    "integrations:read"
#  ]
#}

module "account_read_only_users" {
  for_each  = toset(local.account_read_only_users)
  source    = "./modules/scalr_permission_assignment/"
  email     = each.key
  type      = "account"
  scope_id  = var.scalr_account_id
  role_id   = var.scalr_read_only_role_id
  //  role_id  = scalr_role.example-read-only.id
  providers = {
    scalr = scalr
  }
}
