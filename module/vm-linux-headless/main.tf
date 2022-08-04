# Learn our public IP address
data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

data "azurerm_client_config" "current" {}

locals {
  main_tags        = var.tags
  allowed_list_ips = split(",", coalesce(var.allowed_list_ips, chomp(data.http.icanhazip.body)))
}


resource "azurerm_key_vault" "vm_kv" {
  name                        = "${var.prefix}-kv-${random_string.suffix.id}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true #required for disk encryption 
  tags                        = local.main_tags
  soft_delete_retention_days  = 7
}

resource "azurerm_key_vault_key" "vm_kv" {
  name         = "des-key"
  key_vault_id = azurerm_key_vault.vm_kv.id
  key_type     = "RSA"
  key_size     = 2048
  depends_on = [
    azurerm_key_vault_access_policy.user
  ]

  key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_disk_encryption_set" "vm" {
  name                = "des"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  key_vault_key_id    = azurerm_key_vault_key.vm_kv.id

  identity {
    type = "SystemAssigned"
  }
  tags = local.main_tags
}


resource "azurerm_key_vault_access_policy" "disk" {
  key_vault_id = azurerm_key_vault.vm_kv.id

  tenant_id = azurerm_disk_encryption_set.vm.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.vm.identity.0.principal_id

  key_permissions = ["Get", "WrapKey", "UnwrapKey", "Delete", "Purge", "Recover"]
}

resource "azurerm_key_vault_access_policy" "user" {
  key_vault_id = azurerm_key_vault.vm_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = ["Get", "Create", "Delete", "WrapKey", "UnwrapKey", "Purge", "Recover"]
}

resource "random_pet" "server" {
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.machine_number}-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
  domain_name_label   = lower(random_pet.server.id)
  tags                = local.main_tags
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = local.main_tags
}

resource "azurerm_network_security_group" "access" {
  name                = "${var.prefix}-workstation-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = local.allowed_list_ips
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  tags = local.main_tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.access.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.prefix}-${var.machine_number}-ws"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = var.username
  #admin_password                  = var.password
  #disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id
  ]
  boot_diagnostics {
    storage_account_uri = null
  }

  custom_data = base64encode(file("${path.module}/scripts/${var.init_file}"))

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }


  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "0.20220711.1073"
   # version   = "0.20210814.734"
  }

  os_disk {
    storage_account_type   = "Standard_LRS"
    caching                = "ReadWrite"
    disk_encryption_set_id = azurerm_disk_encryption_set.vm.id
  }

  tags = local.main_tags
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "workstation" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location           = azurerm_resource_group.main.location
  enabled            = true

  daily_recurrence_time = "2230"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}
