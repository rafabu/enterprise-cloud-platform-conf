# Known Issues

This document catalogs known issues, limitations, and workarounds encountered while working with the Enterprise Cloud Platform (ECP) configuration. It serves as a reference for developers to quickly identify common problems and their solutions, reducing debugging time and preventing repeated troubleshooting efforts.

If you encounter a new issue, please document it here following the existing format to help the team.

---

## Azure Resource Provider Not Registered

**Applies to:** Enterprise Cloud Platform for Azure

**When:** Initial onboarding of a new engagement (Organization) or when working with new Azure Subscriptions

### Description

When running `apply` on level0 for the first time, Terraform may fail because required Azure resource providers are not yet registered on the subscription.

### Error Example

```
Error: Failed to perform action

  with data.azapi_resource_action.provider_usage,
  on ado_managed_pool_quota_request.tf line 3, in data "azapi_resource_action" "provider_usage":
   3: data "azapi_resource_action" "provider_usage" {

performing action usages of "Resource: (ResourceId
"/subscriptions/<subscription-id>/providers/Microsoft.DevOpsInfrastructure/locations/northeurope"
/ Api Version "2024-04-04-preview")": GET
https://management.azure.com/subscriptions/<subscription-id>/providers/Microsoft.DevOpsInfrastructure/locations/northeurope/usages
--------------------------------------------------------------------------------
RESPONSE 404: 404 Not Found
ERROR CODE: SubscriptionNotRegistered
--------------------------------------------------------------------------------
{
  "error": {
    "code": "SubscriptionNotRegistered",
    "message": "The subscription '<subscription-id>' is not registered to 'Microsoft.DevOpsInfrastructure'."
  }
}
--------------------------------------------------------------------------------
```

### Cause

New Azure subscriptions do not have all resource providers registered by default. The ECP deployment requires specific providers (such as `Microsoft.DevOpsInfrastructure`) to be registered before certain resources can be queried or created.

### Workaround

Run `terragrunt apply` again. The Enterprise Cloud Platform is designed to register the required resource providers automatically during deployment. The initial apply may fail, but subsequent runs will succeed once the providers are registered.

---

## DevOps Infrastructure Quota Request Failed

**Applies to:** Enterprise Cloud Platform for Azure

**When:** Deploying Managed DevOps Pools on subscriptions with insufficient VM quota

### Description

The Enterprise Cloud Platform automatically requests quota increases for Azure subscriptions. However, in some regions, self-service quota increases are not available for certain VM families. When this happens, the deployment fails because the required quota cannot be fulfilled automatically.

### Error Example

```
Error: Resource postcondition failed

  on ado_managed_pool_quota_request.tf line 102, in data "azapi_resource_action" "provider_usage_recheck":
 102:       condition = [
 103:         for usage in self.output.value : usage.limit
 104:         if lower(usage.name.value) == lower(local.managed_devops_pool_usage.sku_family)
 105:       ][0] >= local.managed_devops_pool_usage.limit + local.managed_devops_pool_usage.this_missing_cpu_count
    ├────────────────
    │ local.managed_devops_pool_usage.limit is 0
    │ local.managed_devops_pool_usage.sku_family is "standardDASv5Family"
    │ local.managed_devops_pool_usage.this_missing_cpu_count is 4
    │ self.output.value is tuple with 161 elements

Microsoft.DevOpsInfrastructure quota request for standardDASv5Family in
region northeurope has not been fulfilled; current limit is still
insufficient.
```

### Cause

The subscription has zero or insufficient quota for the requested VM family (e.g., `standardDASv5Family`). Self-service quota increases may be blocked for specific VM families or regions, preventing ECP from automatically provisioning the required resources.

### Workarounds

**Option 1: Open a Microsoft Support Request**

Manually request a quota increase through the Azure Portal:

1. Navigate to **Subscriptions** > your subscription > **Usage + quotas**
2. Find the relevant VM family (e.g., `Microsoft.DevOpsInfrastructure` for the SKU family shown in the error)
3. Request a quota increase through Microsoft Support

**Option 2: Switch to an Available VM Family**

Override the VM SKU in your engagement's Terragrunt configuration to use a VM family that already has available quota.

**Configuration location:**

```
deployments/managed/{engagement}/dev/level0/launchpad/ado-mpool/terragrunt.hcl
```

**Current default setting:**

```hcl
managed_devops_pool_vmss_fabric_profile = {
  sku_name = "Standard_D2as_v5"  # standardDASv5Family
  ...
}
```

**Alternative VM SKUs:**

| SKU              | Family              | vCPUs | Notes                                  |
|------------------|---------------------|-------|----------------------------------------|
| Standard_D2s_v5  | standardDSv5Family  | 2     | Intel-based, often more available      |
| Standard_D2ds_v5 | standardDDSv5Family | 2     | With local temp disk                   |
| Standard_D2s_v4  | standardDSv4Family  | 2     | Previous generation, widely available  |
| Standard_B2s     | standardBSFamily    | 2     | Burstable, cheaper                     |
| Standard_B2as_v1 | standardBASv1Family | 2     | Burstable AMD, cost-effective          |

**Example override:**

```hcl
inputs = {
  managed_devops_pool_vmss_fabric_profile = {
    sku_name = "Standard_D2s_v5"  # Changed to Intel-based SKU
    image = [
      {
        aliases               = ["ubuntu-24.04/latest"]
        buffer                = "*"
        well_known_image_name = "ubuntu-24.04/latest"
      }
    ]
    os_profile = {
      logon_type = "Service"
    }
    storage_profile = {
      os_disk_storage_account_type = "StandardSSD"
      data_disk                    = []
    }
  }
}
