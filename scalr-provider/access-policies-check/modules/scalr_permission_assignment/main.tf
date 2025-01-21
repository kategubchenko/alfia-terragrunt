terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "2.3.0"
    }
  }
}

// Describe vars
variable "email" {
  description = "The email of the user"
  type        = string
}

variable "type" {
  description = "The scope type for the access policy (e.g., account)"
  type        = string
}

variable "scope_id" {
  description = "The ID of the scope (e.g., Scalr account ID)"
  type        = string
}

variable "role_id" {
  description = "The ID of the role to assign"
  type        = string
}

// Fetch the user info via email
data "scalr_iam_user" "user" {
  email = var.email
}

// Assign role
resource "scalr_access_policy" "assignment" {
  subject {
    type = "user"
    id   = data.scalr_iam_user.user.id
  }

  scope {
    type = var.type
    id   = var.scope_id
  }

  role_ids = [
    var.role_id
  ]
}
