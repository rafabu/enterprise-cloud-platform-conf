locals {
  launchpad_subscription_id    = "e1b3be0d-0df0-4e0a-a585-ffc97f60bd42"

  deployment_env = "dev"

  env_azure_tags = {
    "_ecpTgUnitEnv" = format("%s/env.hcl", get_parent_terragrunt_dir())
    workloadEnvironment  = local.deployment_env
  }
}

inputs = {
}