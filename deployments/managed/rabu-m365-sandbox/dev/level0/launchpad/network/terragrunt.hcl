# includes merge "inputs", with last include taking precedence over previously defined.
#     expose: allows content to be used by "include" 

# root common (via git submodule)
include "root-common" {
  path = format("%s/lib/terragrunt-common/ecp-v1/root-common.hcl", get_repo_root())
  expose = true # allow pulling in tags
}
include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = false
}
include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = false
}
include "level" {
  path = find_in_parent_folders("level.hcl")
  expose = false
}
include "area" {
  path = find_in_parent_folders("area.hcl")
  expose = false
}
# unit common (via git submodule)
include "unit-common" {
  path = format("%s/lib/terragrunt-common/ecp-v1/%s/unit-common.hcl", get_repo_root(), regexall("^.*/(.+?/.+?/.+?)$", get_terragrunt_dir())[0][0])
  expose = false
}

locals {
  module_azure_tags = {
    "_ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())

    workloadBlockName  = "net"
  }
}

inputs = {
 # unit inputs mostly from unit-common.hcl
 azure_tags = merge(
    include.root-common.locals.merged_azure_tags,
    local.module_azure_tags
  )
}

