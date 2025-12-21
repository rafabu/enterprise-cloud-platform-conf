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

    workloadBlockName = "ado"
  }
}

inputs = {
  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags

  # Overwrite to use a different VM family for deployment
  managed_devops_pool_vmss_fabric_profile = {
      sku_name = "Standard_D2as_v5"
      image = [
        {
          aliases               = ["ubuntu-24.04/latest"]
          buffer                = "*"
          well_known_image_name = "ubuntu-24.04/latest"
        }
      ]
      os_profile = {
        logon_type = "Service"
      }
      storage_profile = {
        os_disk_storage_account_type = "StandardSSD"
        data_disk                    = []
      }
    }
}
