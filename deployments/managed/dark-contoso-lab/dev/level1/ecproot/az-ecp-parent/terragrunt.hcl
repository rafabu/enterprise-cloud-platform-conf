# includes merge "inputs", with last include taking precedence over previously defined.
#     expose: allows content (e.g. locals) to be used by "include" 

# root common (via git submodule)
include "root-common" {
  path           = format("%s/lib/terragrunt-common/ecp-v1/root-common.hcl", get_repo_root())
  expose         = false
  merge_strategy = "deep"
}
include "root" {
  path           = find_in_parent_folders("root.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "level" {
  path           = find_in_parent_folders("level.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "area" {
  path           = find_in_parent_folders("area.hcl")
  expose         = false
  merge_strategy = "deep"
}
# unit common (via git submodule)
include "unit-common" {
  path           = format("%s/lib/terragrunt-common/ecp-v1/%s/unit-common.hcl", get_repo_root(), regexall("^.*/(.+?/.+?/.+?)$", get_terragrunt_dir())[0][0])
  expose         = false
  merge_strategy = "deep"
}

locals {
  module_azure_tags = {
    # "hidden-ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())
  }
}

inputs = {
  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags

  ecp_deployment_entraid_contributor_group_member_principal_ids = [
    "7d341c29-3220-4f0c-b154-b08bde0ee92e" # A-Admin
  ]
  ecp_deployment_entraid_reader_group_member_principal_ids      = [
    "05b1d8bc-7b58-4695-9a5e-98029da27119" # C-Admin
  ]
}

