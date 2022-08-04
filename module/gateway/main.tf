
resource "azurerm_public_ip" "hub" {
  name                = "${var.prefix}-hub-ip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hub" {
  name                = "hub-gateway"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.hub.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "hub_to_onprem" {
  name                = "hub-to-onprem"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.hub.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}
