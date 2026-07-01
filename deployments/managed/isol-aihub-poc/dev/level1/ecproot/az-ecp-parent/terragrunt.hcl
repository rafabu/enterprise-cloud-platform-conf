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
  path           = format("%s/lib/terragrunt-common/ecp-v1/%s/unit-common.hcl", get_repo_root(), regexall("^.*(?:\\\\|/)(.+?(?:\\\\|/).+?(?:\\\\|/).+?)$", get_terragrunt_dir())[0][0])
  expose         = false
  merge_strategy = "deep"
}

locals {
  module_azure_tags = {
    # "hidden-ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())
  }
}

inputs = {

  ecp_deployment_entraid_contributor_group_member_principal_ids = [
    "86984e3c-69ef-4cf0-9c37-3c5e940408cd", # Raphael Burri (guest user)
    "c17ad8e5-871f-4d00-a6c1-c4b7841dd573", # Lukas Rottach (guest user)
    "678326f7-78a8-4916-83e8-5671ef662b94", # Cédric Mendelin (guest user)
    "27adb7f0-20f5-47aa-b0a6-7f8996b0058f" # Sebastian Ebner (guest users)
  ]
  ecp_deployment_entraid_reader_group_member_principal_ids = [
    "86984e3c-69ef-4cf0-9c37-3c5e940408cd", # Raphael Burri (guest user)
    "c17ad8e5-871f-4d00-a6c1-c4b7841dd573",  # Lukas Rottach (guest user)
    "678326f7-78a8-4916-83e8-5671ef662b94",  # Cédric Mendelin (guest user)
    "27adb7f0-20f5-47aa-b0a6-7f8996b0058f"  # Sebastian Ebner (guest users)
  ]

  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags
}

