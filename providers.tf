provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false # true gives error
      purge_soft_deleted_keys_on_destroy = false 
      recover_soft_deleted_key_vaults = true
    }
  }
}
