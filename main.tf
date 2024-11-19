provider "azurerm" {
}

resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "East US"
}
