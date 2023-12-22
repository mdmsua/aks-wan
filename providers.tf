terraform {
  cloud {
    organization = "Megamango"
    workspaces {
      project = "wan"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.configuration.tenant_id
  subscription_id = var.configuration.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
