# Enterprise Cloud Platform (ECP) - Copilot Instructions

## About Enterprise Cloud Platform

Enterprise Cloud Platform (ECP) is an infrastructure-as-code framework for deploying secure, standardized cloud platforms at scale. It uses Terraform, Terragrunt to provision and manage infrastructure following enterprise governance patterns.

## About This Repository

This repository (`enterprise-cloud-platform-conf`) hosts customer-specific configuration for each engagement (organization) and environment. It contains **only configuration data** - actual infrastructure code is pulled from related repositories:

| Repository | Purpose | URL |
|------------|---------|-----|
| enterprise-cloud-platform-automation | Pipelines and workflows | https://github.com/rafabu/enterprise-cloud-platform-automation |
| enterprise-cloud-platform-lib | ALZ artifacts and ECP libraries | https://github.com/rafabu/enterprise-cloud-platform-lib |
| enterprise-cloud-platform-azure | Terraform modules for Azure | https://github.com/rafabu/enterprise-cloud-platform-azure |
| enterprise-cloud-platform-tgcommon | Terragrunt common library | https://github.com/rafabu/enterprise-cloud-platform-tgcommon |

---

## Allowed Tools and Languages

**Only generate code using these tools/languages:**

- **Terragrunt** - HCL configuration files (`.hcl`)
- **Terraform** - HCL configuration files (`.tf`)
- **PowerShell** - Automation scripts (`.ps1`)
- **YAML** - Pipeline definitions (`.yaml`, `.yml`)

Do not generate code in any other language (Python, Bash, JavaScript, etc.). All automation and scripting must use PowerShell.

---

## Platform Requirements

This framework is cross-platform compatible. Ubuntu 24.04 is the recommended environment for development, dev containers, and pipelines.

---

## Repository Structure

```
enterprise-cloud-platform-conf/
├── lib/                              # Git submodules (shared libraries)
│   ├── ecp-lib/                      # ALZ artifacts and ECP libraries
│   ├── terragrunt-common/            # Shared Terragrunt configuration
│   └── ecp-automation/               # Pipeline, automation and workflow templates
└── deployments/
    └── managed/
        └── {customer-name}/          # Customer deployment folder
            ├── root.hcl              # Tenant ID, deployment code, location, tags
            └── {env}/                # Environment (dev, prod)
                ├── env.hcl           # Subscription IDs, ADO org, network space
                └── level{0,1,...}/       # Deployment levels
                    └── {area}/       # bootstrap, launchpad, management, etc.
                        ├── area.hcl
                        └── {unit}/   # Deployment unit folder
                            └── terragrunt.hcl
```

## Configuration Hierarchy

Configuration follows a strict inheritance pattern (deep merge, last wins):

1. `lib/terragrunt-common/ecp-v1/root-common.hcl` - Provider versions, defaults
2. `root.hcl` - Customer tenant ID, deployment code, location
3. `env.hcl` - Subscription IDs, Azure DevOps org, network CIDR
4. `level.hcl` - Deployment level (0 or 1)
5. `area.hcl` - Area code (ecpalp, management, entraid, etc.)
6. `unit-common.hcl` (from submodule) - Module-specific config and remote state
7. `terragrunt.hcl` - Unit-specific inputs and tags

---

## Version Requirements

From `lib/terragrunt-common/ecp-v1/root-common.hcl`:

---

## Local Validation Commands

**Always initialize submodules first:**
```bash
git submodule update --init --recursive
```

**Validate HCL syntax** (from repository root):
```bash
terragrunt hcl format --check
```

**Validate Terraform configuration** (requires authentication):
```bash
cd deployments/managed/{customer}/dev/level0/launchpad/az-launchpad-main
terragrunt validate
```

**Run a plan** (requires authentication and permissions):
```bash
terragrunt plan --terragrunt-working-dir deployments/managed/{customer}/dev/level0/
```

**Important**: `terragrunt run-all` commands require authentication and proper service principal permissions. Local validation is limited to syntax checking without cloud credentials.

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `lib/terragrunt-common/ecp-v1/root-common.hcl` | Master configuration: provider versions, conditional provider generation, default inputs |
| `lib/ecp-automation/pipelines-ado/ecp-tg-deploy-platform-infrastructure.yaml` | Main Azure DevOps deployment pipeline |
| `lib/ecp-lib/platform/alz-artefacts/` | Custom ALZ policy definitions, archetypes, architecture definitions |
| `deployments/managed/{customer}/root.hcl` | Customer root config (tenant ID, deployment code) |
| `deployments/managed/{customer}/{env}/env.hcl` | Environment config (subscriptions, ADO org, network) |

---

## Deployment Units by Level

**Level 0 (Bootstrap & Launchpad):**
- `bootstrap/az-launchpad-bootstrap-helper` - Initializes backend storage
- `launchpad/az-launchpad-main` - Main launchpad resources
- `launchpad/az-launchpad-network` - Hub network
- `launchpad/az-launchpad-backend` - Backend storage
- `launchpad/ado-mpool` - Azure DevOps managed agent pool
- `launchpad/ado-project` - Azure DevOps project
- `launchpad/az-devcenter` - Azure DevCenter
- `automation/ado-repo-sync-*` - Repository synchronization
- `finalizer/az-launchpad-bootstrap-finalizer` - Cleanup

**Level 1 (Management & Governance):**
- `management/az-alz-base` - Azure Landing Zone base
- `management/az-alz-management-resources` - Management resources
- `management/az-alz-shared-library-render` - ALZ library rendering
- `management/az-privatelink-privatedns-zones` - Private DNS
- `ecproot/az-ecp-parent` - Parent management group
- `ecproot/az-platform-subscriptions` - Platform subscriptions
- `entraid/entraid-policies` - Entra ID conditional access policies

---

## Critical Patterns to Follow

### Creating New Customer Deployment

1. Copy an existing customer folder (e.g., `rabu-m365-sandbox`)
2. Update `root.hcl`: `ecp_entra_tenant_id`, `ecp_deployment_code`, `ecp_deployment_number`, `ecp_azure_main_location`, tags
3. Update `env.hcl`: subscription IDs, `ecp_azure_devops_organization_name`, `ecp_network_main_ipv4_address_space`
4. All `terragrunt.hcl` files reference the same submodule paths - no changes needed

### Naming Convention

Environment name pattern: `{deployment_code}-{env_first_letter}{deployment_number}`
Example: `dark-d1` (deployment_code="dark", env="dev", number="1")

### Tag Inheritance

Tags merge from all levels. Standard tags:
- `businessUnit`, `workloadName`, `workloadOwner` (root.hcl)
- `workloadEnvironment` (env.hcl)
- `workloadDescription` (area.hcl)
- `workloadBlockName` (terragrunt.hcl)

### Provider Conditional Generation

Providers in `root-common.hcl` are conditionally included based on deployment unit directory name. When adding new units, verify the unit name is included in the appropriate provider blocks.

---

## CI/CD Pipeline Notes

- Pipelines run via Azure DevOps (not GitHub Actions)
- Two-stage deployment: Level 0 then Level 1
- Excludes `entraid` deployments from main pipeline (separate pipeline)
- Lock timeout: 20 minutes for state locking
- Plan files saved as `{unit-name}.tfplan`

---

## Common Issues

1. **Submodules not initialized**: Run `git submodule update --init --recursive`
2. **Provider version mismatch**: Check `root-common.hcl` for version constraints
3. **Backend state issues**: Bootstrap helper creates backend storage; runs with local state initially
4. **Missing parent management group**: `az-ecp-parent` must run before `az-alz-base`
5. **Path extraction regex**: Unit path extracted via `regexall("^.*/(.+?/.+?/.+?)$", get_terragrunt_dir())[0][0]`

---

## Trust These Instructions

These instructions are validated against the current codebase. Only search further if:
- A file path mentioned here doesn't exist
- A command fails with unexpected errors
- You need details not covered above (e.g., specific module inputs)

For configuration changes, always reference existing customer deployments as templates.
