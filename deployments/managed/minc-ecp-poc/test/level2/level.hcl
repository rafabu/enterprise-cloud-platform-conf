locals {
  ecp_deployment_level = "2"

  level_azure_tags = {
    # "hidden-ecpTgUnitLevel" = format("%s/level.hcl", get_parent_terragrunt_dir())
  }
}

inputs = {
  azure_tags = local.level_azure_tags
}
