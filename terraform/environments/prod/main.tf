terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # State backend configuration, separate state files for dev and prod
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatehelloapi"
    container_name       = "tfstate"
    key                  = "prod/hello-api.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

locals {
  environment = "prod"
  app_name    = "hello-api"

  common_tags = {
    environment = local.environment
    app         = local.app_name
    managed_by  = "terraform"
    team        = "devops"
  }
}

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-${local.app_name}-${local.environment}"
  location = var.location
  tags     = local.common_tags
}

module "storage" {
  source = "../../modules/storage"

  name_prefix         = "helloapiprod"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  replication_type = "GRS"

  soft_delete_retention_days = 30

  allowed_ip_ranges = var.allowed_ip_ranges
  tags              = local.common_tags
}
