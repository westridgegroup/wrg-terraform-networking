module "vm_linux_headless" {
    source = "./module/storage"
    subnet_id = azurerm_subnet.onprem_VM.id
    tags = local.tags
    location = var.location
}