/*
module "wrg_firewall" {
  source              = "./module/firewall"
  subnet_id           = azurerm_subnet.hub_firewall_subnet.id
  tags                = local.tags
  location            = var.location
  prefix              = "${var.prefix}stg"
  resource_group_name = azurerm_resource_group.hub.name
}
*/