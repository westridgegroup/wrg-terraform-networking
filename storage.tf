
locals {
  storage = {
    s1 = { network_id = azurerm_virtual_network.hub.id, subnet_id = azurerm_subnet.hub_endpoints.id, prefix = "${var.prefix}1"}
    s2 = { network_id = azurerm_virtual_network.unconnected.id, subnet_id = azurerm_subnet.unconnected_endpoints.id, prefix = "${var.prefix}2"}

  }
}
module "wrg_storage" {
  source     = "./module/storage"
  for_each   = local.storage
  network_id = each.value["network_id"]
  subnet_id  = each.value["subnet_id"]
  tags       = local.tags
  location   = var.location
  prefix     = each.value["prefix"]
}


