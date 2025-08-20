# include {
#   path = find_in_parent_folders("level.hcl")
# }

locals {
    deployment-area = "area-stuff"

    area_azure_tags = {
    workloadDescription  = "Entra ID"
    
  }
}



inputs = {
  basename-area       = "area-name"
}