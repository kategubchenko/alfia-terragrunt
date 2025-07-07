include {
  path = find_in_parent_folders("backend.hcl")
}

terraform {
  source = "../main.tf"
}

locals {
  # Flag inputs (from env)
  exclude_d_from_plan_and_apply    = get_env("EXCLUDE_D_PLAN_APPLY", "false") == "true"
  exclude_d_from_destroy           = get_env("EXCLUDE_D_DESTROY", "false") == "true"
  exclude_d_but_allow_output       = get_env("EXCLUDE_D_ALL_EXCEPT_OUTPUT", "false") == "true"
  exclude_d_for_dev_environment    = get_env("ENV", "") == "dev"

  # Combined logic
  exclude_all                      = local.exclude_d_for_dev_environment
  exclude_plan_apply              = local.exclude_d_from_plan_and_apply
  exclude_destroy                 = local.exclude_d_from_destroy
  exclude_all_except_output       = local.exclude_d_but_allow_output
}

exclude {
  if = local.exclude_all || local.exclude_plan_apply || local.exclude_destroy || local.exclude_all_except_output

  actions = (
    local.exclude_all ? ["all"] :
    local.exclude_all_except_output ? ["all_except_output"] :
    concat(
      local.exclude_plan_apply ? ["plan", "apply"] : [],
      local.exclude_destroy ? ["destroy"] : []
    )
  )

  exclude_dependencies = (
    local.exclude_all || local.exclude_destroy
  )
}

inputs = {
  module_name = "module-d"
  resource_id = "resource-004"
}
