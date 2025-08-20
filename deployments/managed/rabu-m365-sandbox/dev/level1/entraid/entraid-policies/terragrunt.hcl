# includes merge "inputs", with last include taking precedence over previously defined.
#     expose: allows content to be used by "include" 
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


terraform {
  source = "git::git@${include.root.locals.modules_repo}/modules-tf//entraid-policies?ref=${include.root.locals.modules_repo_version}"
}

locals {
  deployment-module = basename(get_terragrunt_dir())
  modules_repo = include.root.locals.modules_repo

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

   library_path_shared = "${get_parent_terragrunt_dir("root")}/../../lib/entraid-policies"
   library_path_module = "${get_terragrunt_dir()}/lib"
   
   library_namedLocation_path_shared = "${local.library_path_shared}/namedLocations"
   library_namedLocation_path_module = "${local.library_path_module}/namedLocations"
   library_namedLocation_filter = "*.microsoft.graph.{country,ip}NamedLocation.json"

   policy_named_location_definition_shared = {
    for fileName in fileset(local.library_namedLocation_path_shared, local.library_namedLocation_filter) : jsondecode(file(format("%s/%s", local.library_namedLocation_path_shared, fileName))).definitionName => jsondecode(file(format("%s/%s", local.library_namedLocation_path_shared, fileName)))
   }
   policy_named_location_definition_module = {
    for fileName in fileset(local.library_namedLocation_path_module, local.library_namedLocation_filter) : jsondecode(file(format("%s/%s", local.library_namedLocation_path_module, fileName))).definitionName => jsondecode(file(format("%s/%s", local.library_namedLocation_path_module, fileName)))
   }
   policy_named_location_definition_merged = merge(
    local.policy_named_location_definition_shared,
    local.policy_named_location_definition_module
   )
}



inputs = {
  basename-module = "module.name"
  environment = include.env.locals.deploymentEnv
  # level = local.area_variable

  azure_tags = local.merged_azure_tags


  # named location artefacts (merged - module definitions can override the library ones)
  named_location_definitions =   local.policy_named_location_definition_merged
  }

