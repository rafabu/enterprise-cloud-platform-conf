# Enterprise Cloud Platform - Configuration Repository

This repository stores the **configuration** for the Enterprise Cloud Platform (ECP). ECP is an agnostic framework designed to deploy Enterprise Platforms at scale across cloud environments.

> **Note:** This repository only contains configuration files. The actual Terragrunt and Terraform code is maintained in separate repositories referenced as git submodules.

## Overview

The Enterprise Cloud Platform enables organizations to:

- Deploy consistent, scalable cloud infrastructure
- Manage multiple customer engagements from a single framework
- Support multiple environments (dev, prod, etc.) per engagement
- Maintain separation of configuration from infrastructure code

## Repository Structure

```
.
├── deployments/                    # All deployment configurations
│   └── managed/                    # Managed deployments
│       └── <engagement>/           # Engagement (organization/customer)
│           └── <environment>/      # Environment (dev, prod, etc.)
│               ├── env.hcl         # Environment-level configuration
│               ├── level0/         # Deployment Level 0 (Launchpad)
│               │   ├── level.hcl
│               │   ├── bootstrap/
│               │   ├── launchpad/
│               │   ├── automation/
│               │   └── finalizer/
│               └── level1/         # Deployment Level 1 (Core Platform)
│                   ├── level.hcl
│                   ├── ecproot/
│                   ├── entraid/
│                   └── management/
├── lib/                            # Shared libraries (git submodules)
│   ├── ecp-lib/                    # ECP core library
│   ├── ecp-automation/             # Automation scripts and pipelines
│   └── terragrunt-common/          # Common Terragrunt configurations
└── README.md
```

## Key Concepts

### Engagements

An **engagement** represents a distinct organization or customer deployment. Each engagement is a top-level folder under `deployments/managed/` (e.g., `rabu-m365-sandbox`). ECP is capable of deploying and managing multiple engagements from a single configuration repository.

### Environments

Each engagement can have multiple **environments** such as `dev`, `staging`, or `prod`. Environments allow for separation of resources and configurations across different deployment stages.

### Deployment Levels

Deployments are organized into levels that represent different phases of the platform:

| Level | Purpose | Components |
|-------|---------|------------|
| **Level 0** | Launchpad & Bootstrap | Initial infrastructure setup, DevOps pipelines, backend storage, networking foundations |
| **Level 1** | Core Platform | Platform subscriptions, Entra ID policies, management resources, Azure Landing Zone base |

### Configuration Hierarchy

Terragrunt configurations follow a hierarchical structure where settings are inherited and merged:

```
root.hcl          → Engagement-wide settings (tenant ID, deployment code, location)
  └── env.hcl     → Environment-specific settings (subscriptions, network ranges)
      └── level.hcl   → Level-specific settings
          └── area.hcl    → Area-specific settings (functional grouping)
              └── terragrunt.hcl  → Unit-specific configuration
```
