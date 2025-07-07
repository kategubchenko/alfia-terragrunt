 include {
  path = find_in_parent_folders("backend.hcl")
}

terraform {
  source = "../main.tf"
}

inputs = {
  module_name = "module-a"
  resource_id = "resource-001"
}
