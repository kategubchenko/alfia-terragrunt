# terraform {
#   source = "../main.tf"
# }

# include {
#   path = find_in_parent_folders("backend.hcl")
# }

# dependencies {
#   paths = ["../module-b"]
# }

# dependency "module-b" {
#   config_path = "../module-b"

#   mock_outputs = {
#     resource_output = {
#       module_name = "mock-module-a"
#       resource_id = "mock-resource-001"
#     }
#   }
# }

# inputs = {
#   module_name = "module-c"
#   resource_id = "resource-003"
#   dependency_info = dependency.module-b.outputs.resource_output
# }
