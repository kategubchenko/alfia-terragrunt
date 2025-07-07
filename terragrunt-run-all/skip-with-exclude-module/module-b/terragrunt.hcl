# include {
#     path = find_in_parent_folders("backend.hcl")
# }

# terraform {
#   source = "../main.tf"
# }

# dependencies {
#   paths = ["../module-a"]
# }

# dependency "module-a" {
#   config_path = "../module-a"
#   mock_outputs = {
#     resource_output = {
#       module_name = "mock-module-a"
#       resource_id = "mock-resource-001"
#     }
#   }
# }

# inputs = {
#   module_name = "module-b"
#   resource_id = "resource-002-alfi-check"
#   dependency_info = dependency.module-a.outputs.resource_output
# }
