locals {

  launchpad_subscription_id    = "e1b3be0d-0df0-4e0a-a585-ffc97f60bd42"

    deploymentEnv = "dev"

       env_azure_tags = {
    workloadEnvironment  = local.deploymentEnv
  }
}






inputs = {
  basename-env       = "env-name"
}