locals {
  main_tags = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-storage-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_storage_account" "hub" {
  name                = "storageaccountname"
  resource_group_name = azurerm_resource_group.main.name

  location                          = azurerm_resource_group.main.location
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  infrastructure_encryption_enabled = true
  min_tls_version                   = "TLS1_2"

  tags = var.tags
}


resource "azurerm_private_endpoint" "hub" {
  name                = "example-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_private_link_service.example.id
    is_manual_connection           = false
  }
}