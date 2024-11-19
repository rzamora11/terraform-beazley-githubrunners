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
    features = {}
}

resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "East US"
}
