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
  - `terragrunt` (>= 1.2.2)
  - `terraform` (>= 1.17.2)

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

All configuration resides within this (example) repository. For a fresh *ECP Deployment*, copy the folder structure of an already existing deployment from deployments/examples.

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

### terraform level0 (launchpad)

Expect this this step to take roughly **20 minutes**, depending on the performance of your dev-box. This step will provide a fully functioning launchpad environment with Azure DevOps Pipelines, Self-Hosted Agent Pool, all the required permissions and core Entra ID groups as well as the terraform *remote backend* in zero-trust setup.

1. Initialize the providers and cache

- `terragrunt run init --working-dir .\level0\ --filter '!bootstrap/**' -- -upgrade`

2. Plan

- `terragrunt run plan --all --working-dir .\level0\ --filter '!bootstrap/**' --filter '!finalizer/**'`

Note: During bootstrapping it is expected to see the odd MOCK value in the planned outputs. This is because no state exists yet, hence terragrunt cannot know the outputs of dependency units.

3. Apply

- `terragrunt run apply --all --working-dir .\level0\ --filter '!bootstrap/**' --filter '!finalizer/**'`

4. Move terraform states to backend

IMPORTANT: Move local terraform states to the ECP Environment cloud backend. Simply re-run either the plan or the apply operation, this time including bootstrap and finalizer:

- `terragrunt run plan --all --working-dir .\level0\`

Bootstrap will temporarily open remote access to the freshly created Azure blob storage account. Following this, at the start of each unit there will be a message by terragrunt's hook similar to this, confirming the move of the local terraform state file to the remote state:

``` txt
INFO: bootstrap_backend_type_changed: 'true'
      remote backend changed from 'local' to 'azurerm'; copying local state to remote now...
      uploading '/c5021ce3-3226-5fca-8395-b0b629d9ff5c/az-launchpad-backend.tfstate' to 'az-launchpad-backend.tfstate' on abcde1stecpalptfbckndl0'
      state file uploaded successfully to remote backend
      removing local state file '/c5021ce3-3226-5fca-8395-b0b629d9ff5c/az-launchpad-backend.tfstate'
```

Note: The bootstrap module should (temporarily) open internet based access to the backend storage account(s). This is required to transfer the states from local to remote. Subsequent ADO pipeline based runs will close off access again.

### terraforming level 1 - 2

Once level 0 (launchpad) is successfully deployed, there are two ways to proceed for the higher levels:

1. DevOps Pipeline Execution (recommended)
2. Manual Execution

Expect less friction regarding network access and permission as well as better performance when working with the DevOps pipeline. However, if inspecting and troubleshooting is required, manual runs might prove more helpful.

A full deployment of level 1 - 2 including Azure Landing Zones, Azure Bastion and Azure Virtual WAN setup might take up to 75 minutes. Of which the following units consume the most time:

- Azure Landing Zone - in level 1:
- Azure Bastion - in level 2:
- Azure Virtual WAN (without VPN Gateway) - in level 2:
- Azure Virtual WAN (with VPN Gateway) - in level 2:

#### terraform level1 and level2 (*pipeline execution*)

Open your Azure DevOps portal on web page dev.azure.com/[ORG]/[PROJECT]/_build?view=folders and prepare the following pipeline:

- **ECP Deploy Platform Infrastructure (Level 0-2)**

Every stage will go through a terraform *plan*, a *review* and then an *apply* job sequence. Reviewing is made easier by checking the `Terraform Plan` tab or optionally the raw terraform plan files in the artifact store of each stage.

NOTE: You may want to configure to execute the stages individually. This is possible by clicking `Next: Resources` on the *Run Pipeline* pane. Re-running level 0 is optional but recommended as the pipeline will fully close down remote access to the terraform backend.

##### ECP Pipeline Stages

- *level 0*
- *level 1 (ecproot)*
- *level 1 (main)*
- *level 2*

#### terraform level1 and level2 (*manual execution*)

When running the Deployment manually, the *bootstrap* module can facilitate re-opening remote access to the terraform backend. Apart from this, only standard terragrunt commands are required. Recommended procedure:

1. Enable remote access to backend

- `terragrunt run plan --working-dir .\level0\bootstrap\az-launchpad-bootstrap-helper\`

2. Plan, review and Apply Level 1 (ecproot)

- `terragrunt run plan --all --working-dir .\level1\ --filter 'ecproot/**'`
- review
- `terragrunt run apply --all --working-dir .\level1\ --filter 'ecproot/**'`

3. Plan, review and Apply Level 1 (main)

- `terragrunt run plan --all --working-dir .\level1\ --filter '!ecproot/**'`
- review
- `terragrunt run apply --all --working-dir .\level1\ --filter '!ecproot/**'`

4. Plan. review and Apply Level 2

- `terragrunt run plan --all --working-dir .\level2\`
- review
- `terragrunt run apply --all --working-dir .\level2\`
