# Developer Guide

This guide provides practical information for developers working with the Enterprise Cloud Platform (ECP) configuration repository. It covers development environment setup, common workflows, and best practices to help you get started quickly and work effectively.

---

## VS Code Dev Containers

In general Enterprise Cloud Platform deployment work cross-platform, but the maintenance and development is fully supported and runs stable on **Ubuntu 24.04**. This matches the operating system used by all CI/CD pipelines, ensuring consistency between local development and automated deployments.

To simplify environment setup and ensure a consistent development experience, this project provides a VS Code Dev Container configuration.

### Getting Started

1. Install [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/) on your host machine
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) in VS Code
3. Open this repository in VS Code
4. When prompted, click **Reopen in Container** (or use the command palette: `Dev Containers: Reopen in Container`)

### Tooling
The Dev Container is configured with all the tooling and extensions required for developing Enterprise Cloud Platform (ECP).

### Environment Variables

The Dev Container does not forward environment variables from the host system. All required variables must be defined inside the container.

To authenticate with Azure using a Service Principal, set the following environment variables:

```bash
export ARM_CLIENT_ID="<your-client-id>"
export ARM_CLIENT_SECRET="<your-client-secret>"
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export ARM_TENANT_ID="<your-tenant-id>"
```

These variables are used by Terraform and Terragrunt for Azure Resource Manager (ARM) authentication.
