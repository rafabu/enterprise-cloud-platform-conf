

locals {

  ecp_entra_tenant_id = "dfe341f0-7056-41e5-b620-a3549e4cd95d"

  ecp_deployment_code   = "ctrl" # Ctrl+Alt+ISOL (Demo Tenant)
  ecp_deployment_number = "1"

  ecp_azure_main_location = "SwitzerlandNorth"

  # define which Azure Landing Zones "Library" should be applied: ALZ or SLZ
  ecp_deployment_alz_library = "slz" # if not provided, defaults to "alz"

  root_azure_tags = {
    # "hidden-ecpTgUnitRoot" = format("%s/root.hcl", get_parent_terragrunt_dir())

    businessUnit  = "enterprise-platform-team"
    workloadName  = "ecpa"
    workloadOwner = "csga-sos1@ctrlaltisol.onmicrosoft.com"
  }
}

inputs = merge(
  {
    azure_tags = local.root_azure_tags
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
  length(try(local.ecp_azure_devops_configuration_repository_name, "")) > 0 ? {
    ecp_azure_devops_configuration_repository_name = local.ecp_azure_devops_configuration_repository_name
  } : {},
  length(try(local.ecp_azure_devops_pool_type, "")) > 0 ? {
    ecp_azure_devops_pool_type = local.ecp_azure_devops_pool_type
  } : {},
  length(try(local.ecp_azure_root_parent_management_group_id, "")) > 0 ? {
    ecp_azure_root_parent_management_group_id = local.ecp_azure_root_parent_management_group_id
  } : {}
)
