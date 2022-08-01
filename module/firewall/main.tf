locals {
  main_tags = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-frw-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_public_ip" "frw" {
  name                = "${var.prefix}-frw-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
  name                = "${var.prefix}-frw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = subnet_id
    public_ip_address_id = azurerm_public_ip.frw.id
  }

  tags = local.main_tags
}

resource "azurerm_firewall_policy" "dns" {
  name                = "${var.prefix}-frwplcy-dns"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}