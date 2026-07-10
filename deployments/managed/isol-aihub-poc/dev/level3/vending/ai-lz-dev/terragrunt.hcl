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
  path = format("%s/lib/terragrunt-common/ecp-v1/%s/az-alz-vending-subscription/unit-common.hcl", get_repo_root(), regexall("^.*(?:\\\\|/)(.+?(?:\\\\|/).+?)(?:\\\\|/).+?$", get_terragrunt_dir())[0][0])

  expose         = false
  merge_strategy = "deep"
}

locals {

 workload_identifier  = "ailz"
 workload_stage  = "dev"



  module_azure_tags = {
    # "hidden-ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())
  }
}

inputs = {
  ########## SHOULD BE DEPENDENCY ##########57
  ecp_parent_management_group_id = "/providers/Microsoft.Management/managementGroups/iaih-d9-mg-ecpa-deployment"
  ecp_parent_management_group_name = "iaih-d9-mg-ecpa-deployment"

  # business_unit       = "????"
  # cost_center         = "0000"
  # data_classification = "internal"

  
  azure_resource_name_elements = {
    prefixes      = []
    name          = local.workload_identifier
    suffixes      = [local.workload_stage]
    random_length = try(local.merged_locals.ecp_resource_name_random_length, 0)
  }

  # workload_owner       = "cedric.mendelin@isolutions.ch"
  # workload_description = "AI Landing Zone (DEV)"

  # workload_maintained_by = "cedric.mendelin@isolutions.ch"


  // workload owner and user configuration
  workload_owner_object_ids = [
    "86984e3c-69ef-4cf0-9c37-3c5e940408cd", # Raphael Burri (guest user)
    "c17ad8e5-871f-4d00-a6c1-c4b7841dd573", # Lukas Rottach (guest user)
    "678326f7-78a8-4916-83e8-5671ef662b94", # Cédric Mendelin (guest user)
    "27adb7f0-20f5-47aa-b0a6-7f8996b0058f", # Sebastian Ebner (guest users)
    "2ff33bfb-ffdc-41f6-99b5-a78c6c751ec8"  # Francisco Rando (guest user)
  ]
  workload_owners_use_pim = false

  workload_user_object_ids = [
    "86984e3c-69ef-4cf0-9c37-3c5e940408cd", # Raphael Burri (guest user)
    "c17ad8e5-871f-4d00-a6c1-c4b7841dd573", # Lukas Rottach (guest user)
    "678326f7-78a8-4916-83e8-5671ef662b94", # Cédric Mendelin (guest user)
    "27adb7f0-20f5-47aa-b0a6-7f8996b0058f", # Sebastian Ebner (guest users)
    "2ff33bfb-ffdc-41f6-99b5-a78c6c751ec8"  # Francisco Rando (guest user)
  ]
  workload_users_use_pim = false

  # use this to override the default location if required
  azure_location = "SwedenCentral"

  # An existing subscription id
  subscription_id = "1a89ff70-00fa-4e2b-ada3-a06776c44465"
  # The destination management group ID for the new subscription.
  subscription_management_group_id = "iaih-d9-mg-ecpa-landingzones-corp"

  # vnet and subnet configuration
  vnet_address_space = [
    "10.1.0.0/24"
  ]

  subnet_configuration = [
    {
      name          = "default"
      address_prefixes = ["10.1.0.0/26"]
      default_outbound_access_enabled = false
      private_endpoint_network_policies = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate = false
      delegations = []
      service_endpoints = []
    },
    {
      name          = "frontend"
      address_prefixes = ["10.1.0.64/26"]
      default_outbound_access_enabled = false
      private_endpoint_network_policies = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate = false
      delegations = [
        "Microsoft.Web/serverFarms"
      ]
      service_endpoints = []
    },
    {
      name          = "ms-foundry"
      address_prefixes = ["10.1.0.128/26"]
      default_outbound_access_enabled = false
      private_endpoint_network_policies = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate = false
      delegations = [
        "Microsoft.App/environments"
      ]
      service_endpoints = []
    },
    {
      name          = "private-endpoints"
      address_prefixes = ["10.1.0.192/26"]
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate = true
      delegations = []
      service_endpoints = []
    }
  ]

  resource_network_communication_mode = "PrivateLink"

  // Azure Virtual WAN connect
  vwan_connect_enabled = true
  vwan_hub_resource_id = "/subscriptions/54a47b01-be16-4ac5-9c2c-a9847076d794/resourceGroups/iaih-d9-rg-ecpa-con-wan-szn/providers/Microsoft.Network/virtualHubs/iaih-d9-vhub-ecpa-con-szn-01"

  // Azure Bastion connect
  bastion_connect_enabled = false
  bastion_vnet_id = "/subscriptions/1a89ff70-00fa-4e2b-ada3-a06776c44465/resourceGroups/iaih-d9-rg-ecpa-lz-dev-vnet/providers/Microsoft.Network/virtualNetworks/iaih-d9-vnet-ecpa-lz-dev-01"
  bastion_resource_id = "/subscriptions/54a47b01-be16-4ac5-9c2c-a9847076d794/resourceGroups/iaih-d9-rg-ecpa-con-wan-szn/providers/Microsoft.Network/bastionHosts/iaih-d9-bastion-ecpa-con-szn-01"

  //NAT Gateway
  nat_gateway_creation_enabled = true
  nat_gateway_public_ip_count = 1
  nat_gateway_connection_enabled = false  # re-use pre-existing NAT gateway
  nat_gateway_resource_id = null

  // AzureDevOps Capabilities
  azure_devops_project_name        = "AI-LZ-Dev"
  azure_devops_project_description = "AI-LZ Development Environment (created by Terraform)"

  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags
}
