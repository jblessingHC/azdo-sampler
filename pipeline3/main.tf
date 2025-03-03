terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.3.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

data azurerm_client_config current {}

variable "arm_client_secret" {}
variable "project_id" {}
variable "repo_id" {}
variable "branch_name" {}

resource "azuredevops_build_definition" "build3" {
  project_id = var.project_id
  name       = "03 - Store the State of TF CLI to AZ Cloud Store"
  path       = "\\pipelines"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.repo_id
    branch_name = var.branch_name
    yml_path    = "pipeline3/azdo-pipeline-03.yml"
  }

  variable {
    name           = "ARM_CLIENT_ID"
    secret_value   = data.azurerm_client_config.current.client_id
    allow_override = false
    is_secret      = true
  }

  variable {
    name           = "ARM_CLIENT_SECRET"
    secret_value   = var.arm_client_secret
    allow_override = false
    is_secret      = true
  }

  variable {
    name           = "ARM_SUBSCRIPTION_ID"
    secret_value   = data.azurerm_client_config.current.subscription_id
    allow_override = false
    is_secret      = true
  }

  variable {
    name           = "ARM_TENANT_ID"
    secret_value   = data.azurerm_client_config.current.tenant_id
    allow_override = false
    is_secret      = true
  }

}
