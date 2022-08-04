
module "wrg_vm_linux_headless" {
  source         = "./module/vm-linux-headless"
  subnet_id      = azurerm_subnet.onprem_VM.id
  tags           = local.tags
  location       = var.location
  machine_number = var.machine_number
}

module "wrg_vm_linux_headless_hub" {
  source         = "./module/vm-linux-headless"
  subnet_id      = azurerm_subnet.hub_VM.id
  tags           = local.tags
  location       = var.location
  machine_number = "002"
}

