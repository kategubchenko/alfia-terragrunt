include {
  path = find_in_parent_folders("backend.hcl")
}

terraform {
  source = "../main.tf"
}

locals {
  should_skip = (
  (get_env("SKIP_MODULE_A", "") == "true") ||
  (try(input("skip_module"), false) == true)
  )
}

inputs = {
  module_name = "module-a"
  resource_id = "resource-001"
  skip_module = false  # can override via CLI or .tfvars
}

skip = local.should_skip
