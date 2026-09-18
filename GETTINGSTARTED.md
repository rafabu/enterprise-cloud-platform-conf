# Getting Started with a fresh ECP Deployment

## Prerequisites

- Entra ID Tenant
- Azure Subscription(s)
- Azure Management Group
- Azure DevOps Organization
- Bootstrapping Console (Linux, Mac or Windows) with:
  - `PowerShell Core` (>7.0)
  - `Bash` (git bash would do)
  - `Azure CLI`
  - `git`
  - `VSCode` (or any other IDE of your choice)
  - `terragrunt` (>= 1.1.5)
  - `terraform` (>= 1.16.0)

### Entra ID Tenant

Choose either an interactive user account or configure an App Registration (Service Principal) with either a certificate or a secret. The initial bootstrapping mandates a few interactive steps executed from a PowerShell terminal, using Azure CLI login (user or service principal).

Permission for the identity initially executing the bootstrapping of a new *ECP Deployment* must be either:

- Global Administrator (easy but overly privileged)
- Restricted Admin rights of:
  - User Administrator
  - Privileged Role Administrator
  - TO BE VERIFIED

### Azure Subscription(s)

Prepare between 1 and 5 (recommended) new Azure Subscriptions (they should be empty) for the ECP Platform Landing Zones (shared services):

- Lauchpad
- Connectivity
- Identity
- Management (required)
- Security

If not provided, resources for any other subscription but `Management` will be installed into the `Management` subscription. There is no supported way to separate those out again later. Hence, it is highly recommended to start with at least 4 (better 5) subscriptions. With 4 the launchpad resources will be merged into management which might be acceptable even for PROD environments.

### Azure Management Group

An ECP Deployment can start right at the *Tenant Root Group*. The recommend approach is to create a dedicated *ECP Root* one level lower. This approach allows to create several, independent ECP Deployments later.

- place all the ECP Platform subscriptions in the prepared Management Group
- RBAC permission required (on the chosen root management group):
  - Owner
  - Management Group Contributor

### Azure DevOps Organization

Identity running the deployment (user or service principal) must have:

- Project Collection Administrator
- Basic license

## Configuration

All configuration lies within this (example) repository. For a fresh *ECP Deployment*, copy the folder structure of an already existing deployment from deployments/examples.

Modify the *.hcl files as required, starting with root.hcl and work down. Most of the terragrunt.hcl config files might be left with their default values for experimental deployments.

The most important configurations are

ecp_entra_tenant_id     root.hcl    Entra Tenant ID
ecp_deployment_code     root.hcl    4 letter code of deployment (customer)
ecp_deployment_number   root.hcl    single digit (defaults to 1)
ecp_azure_main_location root.hcl    Default Azure Location of shared resources

ecp_management_subscription_id      env.hcl     Azure Subscription Id (mandatory)
ecp_launchpad_subscription_id       env.hcl     optional
ecp_connectivity_subscription_id    env.hcl     optional but highly recommended
ecp_identity_subscription_id        env.hcl     optional but highly recommended
ecp_security_subscription_id        env.hcl     optional but highly recommended

ecp_deployment_env                  env.hcl     stage: e.g. prod / tst / int / dev

ecp_network_main_ipv4_address_space env.hcl     /16 IPv4 CIDR range (for entire deployment)

ecp_azure_devops_organization_name  env.hcl     Name of *existing* Azure DevOps Organization
ecp_azure_devops_project_name       env.hcl     Name of Azure DevOps project for the ECP Deployment

## Installation Steps (Basic)

Works best from a PowerShell Core terminal.

### AZ Login

e.g.

- `az login --service-principal --username $env:ARM_CLIENT_ID --password $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID`
- `az login --tenant $env:ARM_TENANT_ID  --use-device-code`

### configuration folder

- `cd [path]/enterprise-cloud-platform-conf\deployments\managed\[deployment folder]\[level]`

### terragrunt bootstrap

setting up the local console's access environment

- `terragrunt run plan --working-dir .\level0\bootstrap\az-launchpad-bootstrap-helper\`

Note: This is a local deployment to the bootstrap console environment only; no actual terraform resources are going to be created on the ECP Cloud services.

### terraform level0

Initialize the providers and cache

- `terragrunt run init --working-dir .\level0\ -- -upgrade`

Plan

- `terragrunt run plan --all --working-dir .\level0\`

Note: During bootstrapping it is expected to see the odd MOCK value in the planned outputs. This is because no state exists yet, hence terragrunt cannot know the outputs of dependency units.

Apply

- `terragrunt run apply --all --working-dir .\level0\`

IMPORTANT: Move local terraform states to the ECP Environment cloud backend. Simply re-run either the plan or the apply operation:

- `terragrunt run apply --all --working-dir .\level0\`

At the start of each unit's there will be a message fro terragrunt's hook similar to this, confirming the move of the local to the remote state:

``` txt
INFO: bootstrap_backend_type_changed: 'true'
      remote backend changed from 'local' to 'azurerm'; copying local state to remote now...
      uploading '/c5021ce3-3226-5fca-8395-b0b629d9ff5c/az-launchpad-backend.tfstate' to 'az-launchpad-backend.tfstate' on abcde1stecpalptfbckndl0'
      state file uploaded successfully to remote backend
      removing local state file '/c5021ce3-3226-5fca-8395-b0b629d9ff5c/az-launchpad-backend.tfstate'
```

Note: The bootstrap module should (temporarily) open internet based access to the backend storage account(s). This is required to transfer the states from local to remote. Subsequent ADO pipeline based runs will close off access again.

### terraform level0 (pipeline execution)

As a quality check, repeat the level0 setup, using the newly created Azure DevOps Pipeline and self-hosted agent pool infrastructure.
