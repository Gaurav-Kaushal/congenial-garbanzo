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

 
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatehelloapi"
    container_name       = "tfstate"
    key                  = "hello-api.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "hello-api"
}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location

  tags = local.common_tags
}


resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}


resource "azurerm_storage_account" "sa" {
  name                     = "${replace(var.app_name, "-", "")}${var.environment}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"  
  kind                     = "StorageV2"
  min_tls_version          = "TLS1_2"           

    allow_nested_items_to_be_public = false

    enable_https_traffic_only = true


  blob_properties {
    delete_retention_policy {
      days = 7
    }
    versioning_enabled = true                    
  }


  network_rules {
    default_action = "Deny"                      
    bypass         = ["AzureServices"]           
    
    #ip_rules = ["<aks-outbound-ip-range>"] 
  }

  lifecycle {
    prevent_destroy = true                       
  }

  tags = local.common_tags
}


resource "azurerm_storage_container" "data" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"             
}


output "storage_account_name" {
  description = "Storage account name for K8s secret"
  value       = azurerm_storage_account.sa.name
}

output "storage_connection_string" {
  description = "Connection string — store as K8s Secret, never in plaintext"
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true                             
}

output "storage_container_name" {
  description = "Blob container name"
  value       = azurerm_storage_container.data.name
}

locals {
  common_tags = {
    environment = var.environment
    app         = var.app_name
    managed_by  = "terraform"
    team        = "devops"
  }
}
