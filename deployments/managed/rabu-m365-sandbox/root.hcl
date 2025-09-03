

locals {

ecp_entra_tenant_id = "19aa2d31-c461-4697-8786-15e6436f6783"

ecp_deployment_code = "rabu" # think as "customer code"
ecp_deployment_number = "7"

  root_azure_tags = {
    "_ecpTgUnitRoot" = format("%s/root.hcl", get_parent_terragrunt_dir())

    businessUnit  = "enterprise-platform-team"
    workloadName = "ecpa"
    workloadOwner = "padmin@3jf0g8.onmicrosoft.com"
  }
}

inputs = {
}