include {
  path = find_in_parent_folders("backend.hcl")
}

terraform {
  source = "../main.tf"
}

locals {
  # Clear and action-specific local flag
  exclude_module_d_from_plan_and_apply = get_env("EXCLUDE_MODULE_D", "false") == "true"
}

exclude {
  if = local.exclude_module_d_from_plan_and_apply
  actions = ["plan", "apply"]
  exclude_dependencies = false
}

inputs = {
  module_name = "module-d"
  resource_id = "resource-004"
}
