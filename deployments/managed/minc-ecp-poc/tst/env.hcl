locals {
  # platform subscriptions
  #    if any is null-guid, its services are merged into management subscription
  #         NOTE: it is recommended to have a 5 subscription platform setup
  ecp_launchpad_subscription_id    = "39bc8fa5-d9c2-453f-bd71-e87f3d4ed98d"
  ecp_management_subscription_id   = "6b6249df-3951-40b8-a490-8633230b5e17"
  ecp_connectivity_subscription_id = "6eb5f4e9-44db-4395-8601-c34ec5959b16"
  ecp_identity_subscription_id     = "f658ee14-ded4-49ba-90af-89e17ba0ac1c"
  ecp_security_subscription_id     = "fb998ced-b201-4a49-a6d0-60198a013a95"

  # must match foler name inside environment directory
  # e.g., if the folder is "tst", this should be "tst" as well
  ecp_deployment_env = "tst"

  ecp_network_main_ipv4_address_space = "10.13.0.0/16" # IPv4 address from which ECP networks will be derived; normally the lowest IP a /16 address space

  ecp_azure_devops_organization_name             = "Monkeys-Incorporated"
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

    managed_devops_pool_maximum_concurrency = null
    managed_devops_pool_vmss_fabric_profile = {
      sku_name = "Standard_D2as_v5"
    }

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
