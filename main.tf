// Test v1
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0" 
    }

  }
}

provider "azurerm" {
    features {}
  client_id       = jsondecode(var.ARM_CREDENTIALS)["clientId"]
  client_secret   = jsondecode(var.ARM_CREDENTIALS)["clientSecret"]
  tenant_id       = jsondecode(var.ARM_CREDENTIALS)["tenantId"]
  subscription_id = jsondecode(var.ARM_CREDENTIALS)["subscriptionId"]
}

resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "West Europe"
}
