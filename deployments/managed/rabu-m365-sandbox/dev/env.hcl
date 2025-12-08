locals {
  # platform subscriptions
  #    if any is null-guid, its services are merged into management subscription
  #         NOTE: it is recommended to have a 5 subscription platform setup
  ecp_management_subscription_id = "5c838b6a-9149-423a-9de4-ff1682f70388"
  ecp_launchpad_subscription_id = "e1b3be0d-0df0-4e0a-a585-ffc97f60bd42"
  ecp_network_subscription_id = "2ad5a985-e423-4a91-aea0-248c51b2e1cc"
  ecp_identity_subscription_id = "00000000-0000-0000-0000-000000000000"
  ecp_security_subscription_id = "00000000-0000-0000-0000-000000000000"

  ecp_deployment_env = "dev"

  ecp_network_main_ipv4_address_space = "10.224.0.0/16" # IPv4 address from which ECP networks will be derived; normally the lowest IP a /16 address space

  ecp_azure_devops_organization_name = "rabuzu-m365"
  ecp_azure_devops_project_name      = "ECP"
  ecp_azure_devops_automation_repository_name   = "ECP.Automation"
  ecp_azure_devops_configuration_repository_name   = "ECP.Configuration"

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
  