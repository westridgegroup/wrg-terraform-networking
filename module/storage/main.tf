resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-storage-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_storage_account" "hub" {
  name                = "storageaccountname"
  resource_group_name = azurerm_resource_group.main.name

  location                 = resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [vars.subnet_id]
  }

  tags = var.tags
}