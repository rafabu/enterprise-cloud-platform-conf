locals {
  # platform subscriptions
  #    if any is null-guid, its services are merged into management subscription
  #         NOTE: it is recommended to have a 5 subscription platform setup
  ecp_management_subscription_id   = "bfc11e60-b4a7-4744-bb97-8440c817782c"
  ecp_launchpad_subscription_id    = "73d18c2c-3e57-4961-8e14-489abac71e96"
  ecp_connectivity_subscription_id = "54a47b01-be16-4ac5-9c2c-a9847076d794"
  ecp_identity_subscription_id     = "69e97ae1-63bb-4c13-947e-78e9a188c145"
  ecp_security_subscription_id     = "e079f04d-a7c1-4db0-97e4-11d0132981b5"

  ecp_deployment_env = "dev"

  ecp_network_main_ipv4_address_space = "10.254.0.0/16" # IPv4 address from which ECP networks will be derived; normally the lowest IP a /16 address space

  ecp_azure_devops_organization_name             = "iaihd9"
  ecp_azure_devops_project_name                  = "ECP"
  ecp_azure_devops_automation_repository_name    = "ECP.Automation"
  ecp_azure_devops_configuration_repository_name = "ECP.Configuration"

  env_azure_tags = {
    # "hidden-ecpTgUnitEnv" = format("%s/env.hcl", get_parent_terragrunt_dir())

    workloadEnvironment = local.ecp_deployment_env
  }
}

inputs = merge(
  {
    azure_tags = local.env_azure_tags
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
  } : {}
)
  