# includes merge "inputs", with last include taking precedence over previously defined.
#     expose: allows content (e.g. locals) to be used by "include" 

# root common (via git submodule)
include "root-common" {
  path           = format("%s/lib/terragrunt-common/ecp-v1/root-common.hcl", get_repo_root())
  expose         = false
  merge_strategy = "deep"
}
include "root" {
  path           = find_in_parent_folders("root.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "level" {
  path           = find_in_parent_folders("level.hcl")
  expose         = false
  merge_strategy = "deep"
}
include "area" {
  path           = find_in_parent_folders("area.hcl")
  expose         = false
  merge_strategy = "deep"
}
# unit common (via git submodule)
include "unit-common" {
  path = format("%s/lib/terragrunt-common/ecp-v1/%s/unit-common.hcl", get_repo_root(), regexall("^.*(?:\\\\|/)(.+?(?:\\\\|/).+?(?:\\\\|/).+?)$", get_terragrunt_dir())[0][0])

  expose         = false
  merge_strategy = "deep"
}

locals {
  module_azure_tags = {
    # "hidden-ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())
  }
}

inputs = {
  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags

  # Azure vWAN Settings that could be overridden
  # virtual_wan_hubs = {
  #   "ecpa-default-location" = {
  #     # Basic (default) / Standard
  #     sku = "Standard"
  #   }
  # }


  ecp_archetype_definitions = {

    virtual_wan = [
      "l2-connectivity-vwan-basic-sku"
    ]
    virtual_hub = [
      "l2-connectivity-default-vwan-hub"
    ]
    vpn_gateway = []
    vpn_site = [
      # "l2-connectivity-example-staticrouting-vpnsite"
    ]
    vpn_connection = [
      # "l2-connectivity-example-vpnConnection"
    ]
    er_gateway    = []
    er_connection = []
  }

  # OPTIONAL - additional VWAN Hubs
  # allows specifying additional vWAN hub locations
  # ecp_hub_locations = {
  #   "netherlands" = {
  #     azure_location                      = "westeurope"
  #     ecp_network_main_ipv4_address_space = "10.1.0.0/16"
  #     is_main_location                    = false
  #   }
  #   "ireland" = {
  #     azure_location                      = "northeurope"
  #     ecp_network_main_ipv4_address_space = "10.2.0.0/16"
  #     is_main_location                    = false
  #   }
  #   "frankfurt" = {
  #     azure_location                      = "germanywestcentral"
  #     ecp_network_main_ipv4_address_space = "10.3.0.0/16"
  #     is_main_location                    = false
  #   }
  #   "gaevle" = {
  #     azure_location                      = "swedencentral"
  #     ecp_network_main_ipv4_address_space = "10.5.0.0/16"
  #     is_main_location                    = false
  #   }
  # }
}

