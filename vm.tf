
locals {
    vms = {
        vm1 = {subnet_id=azurerm_subnet.onprem_VM.id,machine_number=var.machine_number, init_file="cloud-init-debian-11-A.sh"},
        vm2 = {subnet_id=azurerm_subnet.hub_VM.id,machine_number="002", init_file="cloud-init-debian-11-A.sh"},
        vm3 = {subnet_id=azurerm_subnet.hub_dns_subnet.id,machine_number="003", init_file="cloud-init-debian-11-bind9.sh"}
    }
    onprem = {
        vm4 = {subnet_id=azurerm_subnet.onprem_DNS.id, machine_number="004", init_file="cloud-init-debian-11-bind9-onprem.sh"}
    }
}

module "wrg_vm_linux_headless" {
  source         = "./module/vm-linux-headless"
  for_each = local.vms
  subnet_id      = each.value["subnet_id"]
  tags           = local.tags
  location       = var.location
  machine_number = each.value["machine_number"]
  init_file = each.value["init_file"]
}

module "wrg_vm_linux_headless_onprem" {
  source         = "./module/vm-linux-headless"
  for_each = local.onprem
  subnet_id      = each.value["subnet_id"]
  tags           = local.tags
  location       = var.location
  machine_number = each.value["machine_number"]
  init_file = each.value["init_file"]
}