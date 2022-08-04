locals {
  main_tags = var.tags
}

resource "azurerm_public_ip" "frw" {
  name                = "${var.prefix}-frw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
  name                = "${var.prefix}-frw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.frw.id
  }

  tags = local.main_tags
}

resource "azurerm_firewall_policy" "dns" {
  name                = "${var.prefix}-frwplcy-dns"
  resource_group_name = var.resource_group_name
  location            = var.location

  dns {
    proxy_enabled = true
    servers = null
  }
}