locals {
  launchpad_resource_group_name         = "rabu-d7-rg-ecpalp-level1"
  launchpad_storage_account_name        = "rabud7saecpalpl1"

  deployment_level = "1"

  level_azure_tags = {
          "_ecpTgUnitLevel" = format("%s/level.hcl", get_parent_terragrunt_dir())
    # Owner  = "platform-team"
    # Project = "cloud-platform"
  }
}

inputs = {
}
