locals {
  tags = merge(var.tags, var.env_tags)
}

# Hub vnet
resource "azurerm_resource_group" "hub" {
  name     = "${var.prefix}-vnet-hub"
  location = "eastus2"
  tags     = local.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-vnet-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = local.tags
}

resource "azurerm_subnet" "hub_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "hub_endpoints" {
  name                 = "HubEndpoints"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "hub_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.4.0/24"]
}

/*
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
*/

#"On-Prem" Vnet
resource "azurerm_resource_group" "onprem" {
  name     = "${var.prefix}-vnet-on-prem"
  location = "eastus2"
  tags     = local.tags
}

resource "azurerm_virtual_network" "onprem" {
  name                = "${var.prefix}-vnet-onprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  address_space       = ["10.1.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = local.tags
}

resource "azurerm_subnet" "onprem_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "onprem_DNS" {
  name                 = "onprem-dns"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "onprem_VM" {
  name                 = "onprem-vm"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.1.3.0/24"]
}
/*
resource "azurerm_public_ip" "onprem" {
  name                = "${var.prefix}-onprem-ip"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "onprem" {
  name                = "onprem-gateway"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.onprem.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_gateway.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onprem_to_hub" {
  name                = "onprem-to-hub"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.onprem.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}
*/