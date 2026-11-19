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
    "db3dec32-1c26-43fb-b208-4f30cddc4081", # adm.raphael.burri@ctrlaltisol.onmicrosoft.com
    "972a15d7-16ab-4045-b130-4124eb6599f5", # adm.elia.frei@ctrlaltisol.onmicrosoft.com
    "0ed7cac8-a986-45ca-a61a-25e4ed7b2984", # adm.lukas.rottach@ctrlaltisol.onmicrosoft.com
    "ee70ee6f-01b4-42c1-b2b5-04a282b7aa6f"  # adm.yannic.ehrsam@ctrlaltisol.onmicrosoft.com
  ]
  ecp_deployment_entraid_reader_group_member_principal_ids = [
    "db3dec32-1c26-43fb-b208-4f30cddc4081", # adm.raphael.burri@ctrlaltisol.onmicrosoft.com
    "972a15d7-16ab-4045-b130-4124eb6599f5", # adm.elia.frei@ctrlaltisol.onmicrosoft.com
    "0ed7cac8-a986-45ca-a61a-25e4ed7b2984", # adm.lukas.rottach@ctrlaltisol.onmicrosoft.com
    "ee70ee6f-01b4-42c1-b2b5-04a282b7aa6f"  # adm.yannic.ehrsam@ctrlaltisol.onmicrosoft.com
  ]

  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags
}
