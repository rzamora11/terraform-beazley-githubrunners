// Terraform configuration for a simplified Azure VM v0
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

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "West Europe"
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "demo-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine (Simplified)
resource "azurerm_linux_virtual_machine" "example" {
  name                = "demo-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"  # You can change this to a different size if needed
  admin_username      = "azureuser"    # Default username for Linux VM

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Removed SSH key configuration
  # Allow password authentication
  admin_password = "DoesItWork?"
  disable_password_authentication = false
}
