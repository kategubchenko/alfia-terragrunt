terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "3.2.0" //select latest version
    }
  }
}

variable "hostname" {
  default = "bar-github.main.scalr.dev"
}
variable "api_token" {
  default = ""
}

variable "account_id" {
  default = ""
}

variable "environment_id" {
  default = ""
}

variable "vcs_provider_id" {
  default = ""
}


#PROVIDER
provider "scalr" {
  hostname = var.hostname
  token    = var.api_token
}

#CREATE ENVIRONMENTS WITH COUNT_INDEX
resource "scalr_environment" "migration" {
  count                   = 20
  name                    = "provider-env-${count.index}"
  account_id              = var.account_id
}
#GET ENVIRONMENTS BY COUNT_INDEX

data "scalr_environment" "created" {
  count      = 20
  name       = "provider-env-${count.index}"
  account_id = var.account_id
}

# CREATE VSC-DRIVEN WORKSPACES
resource "scalr_workspace" "vcs-driven" {
  count           = 20
  name            = "vcs-driven-prov-${count.index}"
  environment_id    = data.scalr_environment.created[floor(count.index / 10)].id
  vcs_provider_id = var.vcs_provider_id

  working_directory = "tf-nullresouce-ip"

  vcs_repo {
    identifier       = "Heshercat/tf-magicanimals-plan" //repo example
    branch           = "master"
    dry_runs_enabled = true
  }
}

resource "scalr_workspace" "example-cli" {
  count             = 200
  name              = "my-workspace-name-${count.index}"
  environment_id    = data.scalr_environment.created[floor(count.index / 10)].id
  working_directory = "example/path"
}
