# includes merge "inputs", with last include taking precedence over previously defined.
#     expose: allows content to be used by "include" 

# root common (via git submodule)
include "root-common" {
  path = format("%s/lib/terragrunt-common/ecp-v1/root-common.hcl", get_repo_root())
  expose = false
}
include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}
include "level" {
  path = find_in_parent_folders("level.hcl")
  expose = true
}
include "area" {
  path = find_in_parent_folders("area.hcl")
  expose = true
}
# unit common (via git submodule)
include "unit-common" {
  path = format("%s/lib/terragrunt-common/ecp-v1/%s/unit-common.hcl", get_repo_root(), regexall("^.*/(.+?/.+?/.+?)$", get_terragrunt_dir())[0][0])
  expose = false
}

terraform {
  source = "git::${include.root.locals.azure_modules_repo}/modules-tf//entraid-policies" # ?ref=${include.root.locals.azure_modules_repo_version}"
}

locals {
  module_azure_tags = {
    workloadBlockName  = "pol"
    createdBy = "ecpa-terraform"
  }

  merged_azure_tags = merge(
    include.root.locals.root_azure_tags,
    include.env.locals.env_azure_tags,
    include.level.locals.level_azure_tags,
    include.area.locals.area_azure_tags,
    local.module_azure_tags
  )
}

inputs = {
 # unit inputs mostly from unit-common.hcl
}

