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

  workload_identifier = "mnkvdi"
  workload_stage      = "test"

  module_azure_tags = {
    # "hidden-ecpTgUnit" = format("%s/terragrunt.hcl", get_terragrunt_dir())
  }
}

inputs = {


  azure_resource_name_elements = {
    prefixes      = []
    name          = local.workload_identifier
    suffixes      = [local.workload_stage]
    random_length = try(local.merged_locals.ecp_resource_name_random_length, 0)
  }

  // workload owner and user configuration
  workload_owners_group_member_object_ids = [
    "34fc5804-c082-46a2-84f8-d1ac9b258a7f" # Simon Leu (guest users)

  ]

  workload_owners_group_owners_object_ids = [
    "34fc5804-c082-46a2-84f8-d1ac9b258a7f" # Simon Leu (guest users)

  ]

  workload_owners_group_use_pim = true

  workload_users_group_member_object_ids = [
    "34fc5804-c082-46a2-84f8-d1ac9b258a7f" # Simon Leu (guest users)
  ]
  workload_users_group_owners_object_ids = [
    "34fc5804-c082-46a2-84f8-d1ac9b258a7f" # Simon Leu (guest users)
  ]
  workload_users_group_use_pim = false

  # use this to override the default location if required
  # azure_location = "SwedenCentral"

  # An existing subscription id
  subscription_id = "fc0b7aad-2711-4b4e-bd91-a0d898583fad"
  # The destination management group ID for the new subscription.
  subscription_management_group_id = "minc-t1-mg-ecpa-landingzones-corp"

  # vnet and subnet configuration
  vnet_address_space = [
    "10.13.128.0/23"
  ]

  subnet_configuration = [
    {
      name                                  = "vm-imagebuilder-build"
      address_prefixes                      = ["10.13.128.0/27"]
      default_outbound_access_enabled       = false
      private_endpoint_network_policies     = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = false
      delegations                           = []
      service_endpoints                     = []
    },
    # image building in private subnet (support regulated)
    {
      name                                  = "vm-imagebuilder-aci"
      address_prefixes                      = ["10.13.128.32/27"]
      default_outbound_access_enabled       = false
      private_endpoint_network_policies     = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = false
      delegations = [
        "Microsoft.ContainerInstance/containerGroups"
      ]
      service_endpoints = []
    },
    {
      name                                  = "vdi-management"
      address_prefixes                      = ["10.13.128.64/27"]
      default_outbound_access_enabled       = false
      private_endpoint_network_policies     = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = false
      delegations                           = []
      service_endpoints                     = []
    },
    # {
    #   name                                  = "RESERVED-01"
    #   address_prefixes                      = ["10.224.128.96/27"]
    #   default_outbound_access_enabled       = false
    #   private_endpoint_network_policies     = "Disabled"
    #   private_link_service_network_policies = "Disabled"
    #   private_endpoint_allocate             = false
    #   delegations = []
    #   service_endpoints = []
    # },
    {
      name                                  = "private-endpoints"
      address_prefixes                      = ["10.13.128.128/26"]
      private_endpoint_network_policies     = "NetworkSecurityGroupEnabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = true
      delegations                           = []
      service_endpoints                     = []
    },
    # {
    #   name                                  = "RESERVED-02"
    #   address_prefixes                      = ["10.224.128.192/26"]
    #   default_outbound_access_enabled       = false
    #   private_endpoint_network_policies     = "Disabled"
    #   private_link_service_network_policies = "Disabled"
    #   private_endpoint_allocate             = false
    #   delegations = []
    #   service_endpoints = []
    # },
    {
      name                                  = "avd-sessionhosts"
      address_prefixes                      = ["10.13.129.0/26"]
      default_outbound_access_enabled       = false
      private_endpoint_network_policies     = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = false
      delegations                           = []
      service_endpoints                     = []
    },
    {
      name                                  = "w365-cloudpcs"
      address_prefixes                      = ["10.13.129.64/26"]
      default_outbound_access_enabled       = false
      private_endpoint_network_policies     = "Disabled"
      private_link_service_network_policies = "Disabled"
      private_endpoint_allocate             = false
      delegations                           = []
      service_endpoints                     = []
    },
    # {
    #   name                                  = "RESERVED-03"
    #   address_prefixes                      = ["10.224.129.128/25"]
    #   default_outbound_access_enabled       = false
    #   private_endpoint_network_policies     = "Disabled"
    #   private_link_service_network_policies = "Disabled"
    #   private_endpoint_allocate             = false
    #   delegations = []
    #   service_endpoints = []
    # }
  ]

  resource_network_communication_mode = "PrivateLink"

  // Azure Virtual WAN connect
  vwan_connect_enabled = true
  # if location isn't given, uses either a hub in the same or the default (main) location
  # vwan_hub_location = "WestEurope"

  // Azure Bastion connect
  bastion_connect_enabled = true

  //NAT Gateway
  nat_gateway_creation_enabled   = true
  nat_gateway_public_ip_count    = 1
  nat_gateway_connection_enabled = false # if true: re-use pre-existing NAT gateway (must provide nat_gateway_resource_id)
  nat_gateway_resource_id        = null

  // AzureDevOps Capabilities
  azure_devops_project_name        = "Monkey-VDI-LZ"
  azure_devops_project_description = "VDI-Sandbox-LZ Development Environment (created by Terraform)"

  # unit inputs mostly from unit-common.hcl
  azure_tags = local.module_azure_tags
}
