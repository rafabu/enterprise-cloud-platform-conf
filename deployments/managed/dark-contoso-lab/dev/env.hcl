locals {
  # Platform Subscriptions
  #    if any is null-guid, its services are merged into management subscription
  #    NOTE: it is recommended to have a 5 subscription platform setup

  ecp_management_subscription_id   = "8213f3ae-159c-4de6-a144-ee6866ee14a4"
  ecp_launchpad_subscription_id    = "1d2c9d67-81ae-474a-be6d-d8553bc54e7d"
  ecp_connectivity_subscription_id = "20368bdb-961b-4a4d-9b81-b7db95c52ce6"
  ecp_identity_subscription_id     = "00000000-0000-0000-0000-000000000000"
  ecp_security_subscription_id     = "00000000-0000-0000-0000-000000000000"

  ecp_deployment_env = "dev"

  # IPv4 address from which ECP networks will be derived; normally the lowest IP a /16 address space
  ecp_network_main_ipv4_address_space = "10.110.0.0/16"

  ecp_azure_devops_organization_name = "dark-contoso-lab"
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
