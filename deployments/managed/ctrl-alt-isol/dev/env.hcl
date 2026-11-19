locals {
  # platform subscriptions
  #    if any is null-guid, its services are merged into management subscription
  #         NOTE: it is recommended to have a 5 subscription platform setup
  ecp_launchpad_subscription_id    = "ee55f3f3-ba81-4d74-bd29-2b9d8cc10139"
  ecp_management_subscription_id   = "13acce06-1c3d-444c-9d48-a9cf7369deef"
  ecp_connectivity_subscription_id = "63482c14-53db-4c7d-ad9f-e2ad56c59cea"
  ecp_identity_subscription_id     = "2a5449d7-7b94-4771-8ca0-b4d6fdc1c3ed"
  ecp_security_subscription_id     = "6c3e1db1-6e02-4aab-a869-8cdb5219e475"

  # must match folder name inside environment directory
  # e.g., if the folder is "tst", this should be "tst" as well
  ecp_deployment_env = "dev"

  ecp_network_main_ipv4_address_space = "10.1.0.0/16" # IPv4 address from which ECP networks will be derived; normally the lowest IP a /16 address space

  ecp_azure_devops_organization_name             = "ctrlaltisol"
  ecp_azure_devops_project_name                  = "ECP"
  ecp_azure_devops_automation_repository_name    = "ECP.Automation"
  ecp_azure_devops_configuration_repository_name = "ECP.Configuration"
  ecp_azure_devops_pool_type                     = "ManagedDevOpsPool" # <<< change to 'MicrosoftHosted' if no quota is available

  env_azure_tags = {
    # "hidden-ecpTgUnitEnv" = format("%s/env.hcl", get_parent_terragrunt_dir())

    workloadEnvironment = local.ecp_deployment_env
  }
}

inputs = merge(
  {
    azure_tags = local.env_azure_tags

    # deploy only the private DNS zones we actually need for ACP Demo
    # - storage account
    # - key vault
    private_link_private_dns_zones_regex_filter = "^privatelink\\.(?:azurewebsites\\.net|blob\\.core\\.windows\\.net|file\\.core\\.windows\\.net|queue\\.core\\.windows\\.net|table\\.core\\.windows\\.net|vaultcore\\.azure\\.net)$"
  },
  length(try(local.ecp_azure_main_location, "")) > 0 ? {
    azure_location = local.ecp_azure_main_location
  } : {},
  length(try(local.ecp_network_main_ipv4_address_space, "")) > 0 ? {
    ecp_network_main_ipv4_address_space = local.ecp_network_main_ipv4_address_space
  } : {},
  length(try(local.ecp_azure_devops_organization_name, "")) > 0 ? {
    ecp_azure_devops_organization_name = local.ecp_azure_devops_organization_name
  } : {},
  length(try(local.ecp_azure_devops_project_name, "")) > 0 ? {
    ecp_azure_devops_project_name = local.ecp_azure_devops_project_name
  } : {},
  length(try(local.ecp_azure_devops_automation_repository_name, "")) > 0 ? {
    ecp_azure_devops_automation_repository_name = local.ecp_azure_devops_automation_repository_name
  } : {},
  length(try(local.ecp_azure_root_parent_management_group_id, "")) > 0 ? {
    ecp_azure_root_parent_management_group_id = local.ecp_azure_root_parent_management_group_id
  } : {},
  length(try(local.ecp_azure_devops_pool_type, "")) > 0 ? {
    ecp_azure_devops_pool_type = local.ecp_azure_devops_pool_type
  } : {}
)
