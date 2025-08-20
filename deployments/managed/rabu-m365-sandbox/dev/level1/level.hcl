
     
locals {

  launchpad_resource_group_name         = "rabu-d7-rg-ecpalp-level1"
  launchpad_storage_account_name        = "kpzhd7saecpalplpl1"


    deployment-level = "1"

        level_azure_tags = {
    # Owner  = "platform-team"
    # Project = "cloud-platform"
  }
}



inputs = {
  basename-level       = "level-name"
}
