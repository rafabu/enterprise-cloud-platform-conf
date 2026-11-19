locals {
  ecp_deployment_area = "ecparoot"

  area_azure_tags = {
    # "hidden-ecpTgUnitArea" = format("%s/area.hcl", get_parent_terragrunt_dir())

    workloadDescription = local.ecp_deployment_area
  }
}

inputs = {
  azure_tags = local.area_azure_tags
}
