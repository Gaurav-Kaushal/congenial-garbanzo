terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Basic resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-hello-api"
  location = "eastus"
}

# Storage account for blob data
resource "azurerm_storage_account" "sa" {
  name                     = "hellostorage${random_string.suffix.result}" # must be globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  kind                     = "StorageV2"

  allow_blob_public_access = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Blob container for app data
resource "azurerm_storage_container" "data" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "public"
}
