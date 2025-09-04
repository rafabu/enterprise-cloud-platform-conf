locals {
  ecp_deployment_area = "ecpalp"
  
  area_azure_tags = {
    "_ecpTgUnitArea" = format("%s/area.hcl", get_parent_terragrunt_dir())

    workloadDescription  = local.ecp_deployment_area
  }
}

inputs = {
}