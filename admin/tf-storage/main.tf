terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.96.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.az_subscription
  client_id       = var.az_app_id
  client_secret   = var.az_sp_secret
  tenant_id       = var.az_tenant_id
}

resource "azurerm_storage_account" "training_workshop_data" {
  name                     = "trainingworkshopdata"
  resource_group_name      = var.az_resource_group_name
  location                 = var.az_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "students" {
  name                  = "students"
  storage_account_name  = azurerm_storage_account.training_workshop_data.name
  container_access_type = "private"
}