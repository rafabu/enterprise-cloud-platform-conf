

locals {

entra_id_tenant_id = "19aa2d31-c461-4697-8786-15e6436f6783"

deployment_code = "rabu" # think as "customer code"
deployment_number = "7"

  root_azure_tags = {
    

    businessUnit  = "enterprise-platform-team"
    workloadName = "ecpa"
    workloadOwner = "padmin@3jf0g8.onmicrosoft.com"
  }
}

inputs = {
}