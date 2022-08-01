locals {
  main_tags = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-storage-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_storage_account" "hub" {
  name                = "${var.prefix}accountname"
  resource_group_name = azurerm_resource_group.main.name

  location                          = azurerm_resource_group.main.location
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  infrastructure_encryption_enabled = true
  min_tls_version                   = "TLS1_2"

  tags = var.tags
}

resource "azurerm_private_dns_zone" "hub" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "vnet_link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.hub.name
  virtual_network_id    = var.network_id
}

resource "azurerm_private_endpoint" "hub" {
  name                = "${var.prefix}-storage-endpoint"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.hub.id
    is_manual_connection           = false
    subresource_names = ["blob"]
  }
}

resource "azurerm_private_dns_a_record" "dns_a" {
  name                = "arecord"
  zone_name           = azurerm_private_dns_zone.hub.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.hub.private_service_connection.0.private_ip_address]
}