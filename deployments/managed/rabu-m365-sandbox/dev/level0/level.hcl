locals {
  ecp_launchpad_resource_group_name         = "rabu-d7-rg-ecpalp-level0"
  ecp_launchpad_storage_account_name        = "rabud7saecpalpl0"

  ecp_deployment_level = "0"

  level_azure_tags = {
          "hidden-ecpTgUnitLevel" = format("%s/level.hcl", get_parent_terragrunt_dir())


  }
}

inputs = {
  azure_tags = local.level_azure_tags
}
