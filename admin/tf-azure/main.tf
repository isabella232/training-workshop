terraform {
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


# resource "azurerm_app_service_plan" "workshop_website_plan" {
#   name                = var.az_app_service_plan_name
#   location            = var.az_location
#   resource_group_name = var.az_resource_group_name
#   kind = "app"

#   sku {
#     tier = "Basic"
#     size = "B1"
#   }
# }

data "azurerm_app_service_plan" "workshop_website_plan" {
  name                = var.az_app_service_plan_name
  resource_group_name = var.az_resource_group_name
}

resource "azurerm_app_service" "web_site_dev" {
  name = "${var.student_slug}-dev"
  location = var.az_location
  resource_group_name = var.az_resource_group_name
  app_service_plan_id = data.azurerm_app_service_plan.workshop_website_plan.id
}

resource "azurerm_app_service" "web_site_test" {
  name = "${var.student_slug}-test"
  location = var.az_location
  resource_group_name = var.az_resource_group_name
  app_service_plan_id = data.azurerm_app_service_plan.workshop_website_plan.id
}

resource "azurerm_app_service" "web_site_prod" {
  name = "${var.student_slug}-prod"
  location = var.az_location
  resource_group_name = var.az_resource_group_name
  app_service_plan_id = data.azurerm_app_service_plan.workshop_website_plan.id
}

