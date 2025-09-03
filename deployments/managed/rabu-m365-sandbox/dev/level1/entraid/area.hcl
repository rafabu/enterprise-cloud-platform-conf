locals {
    area_azure_tags = {
    "_ecpTgUnitArea" = format("%s/area.hcl", get_parent_terragrunt_dir())
    workloadDescription  = "Entra ID"
  }
}

inputs = {
}