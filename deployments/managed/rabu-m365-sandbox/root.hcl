locals {
    env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    level_vars = read_terragrunt_config(find_in_parent_folders("level.hcl"))
    area_vars = read_terragrunt_config(find_in_parent_folders("level.hcl"))
    merged_locals = merge(
      local.env_vars.locals,
      local.level_vars.locals,
      local.area_vars.locals
    )
  launchpad_subscription_id      =  local.merged_locals.launchpad_subscription_id
  launchpad_resource_group_name  = local.merged_locals.launchpad_resource_group_name
  launchpad_storage_account_name = local.merged_locals.launchpad_storage_account_name

  modules_repo = "https://github.com:rafabu/enterprise-cloud-platform-azure.git"
  modules_repo_version      = "main"

  root_local = "root-stuff"


deploymentCode = "rabu" # think as "customer code"
deploymentNumber = "7"
environmentName = lower("${local.deploymentCode}-${substr(local.merged_locals.deploymentEnv, 0, 1)}${local.deploymentNumber}")

  root_azure_tags = {
    environmentName = local.environmentName
    businessUnit  = "enterprise-platform-team"
    workloadName = "ecpa"
    workloadOwner = "padmin@3jf0g8.onmicrosoft.com"
  }
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    subscription_id      = local.launchpad_subscription_id
    resource_group_name  = local.launchpad_resource_group_name
    storage_account_name = local.launchpad_storage_account_name
    container_name       = "tfstate"
    use_azuread_auth     = true
    key                  = "${basename(path_relative_to_include())}.tfstate"
  }
  disable_init = tobool(get_env("TERRAGRUNT_DISABLE_INIT", "false"))
}



inputs = {
  basename-root       = "root-name"

 
}