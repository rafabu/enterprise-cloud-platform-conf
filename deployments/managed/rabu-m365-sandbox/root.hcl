

locals {

ecp_entra_tenant_id = "19aa2d31-c461-4697-8786-15e6436f6783"

ecp_deployment_code = "rabu" # think as "customer code"
ecp_deployment_number = "7"

ecp_azure_main_location = "SwitzerlandNorth"


  root_azure_tags = {
    "hidden-ecpTgUnitRoot" = format("%s/root.hcl", get_parent_terragrunt_dir())

    businessUnit  = "enterprise-platform-team"
    workloadName = "ecpa"
    workloadOwner = "padmin@3jf0g8.onmicrosoft.com"
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
  length(try(local.ecp_azure_devops_repository_name, "")) > 0 ? {
      ecp_azure_devops_repository_name = local.ecp_azure_devops_repository_name
  } : {},
  length(try(local.ecp_azure_root_parent_management_group_id, "")) > 0 ? {
      ecp_azure_root_parent_management_group_id = local.ecp_azure_root_parent_management_group_id
  } : {}
)
