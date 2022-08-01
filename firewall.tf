module "wrg_firewall" {
  source     = "./module/firewall"
  network_id = azurerm_virtual_network.hub.id
  subnet_id  = azurerm_subnet.hub_endpoints.id
  tags       = local.tags
  location   = var.location
  prefix     = "${var.prefix}stg"
}