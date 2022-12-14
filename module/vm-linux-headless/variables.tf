variable "subnet_id" {
  type        = string
  description = "The Subnet the VM is added to"
}

variable "tags" {
  type        = map(any)
  description = "Tags to be added to the resources"
}

variable "allowed_list_ips" {
  type        = string
  description = "The IP addresses that will be allowed to talk to the workstation controlled by the NSG; simple comma-delimited list"
  default     = null
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this module"
  default     = "eastus2"
}

variable "init_file" {
  type = string
  description = "The name of the cloud init file we want to use"
  default = "cloud-init-debian-11-A.sh"
}

variable "username" {
  type    = string
  default = "adminuser"
}

variable "password" {
  type    = string
  default = "P@ssw0rd1234!"
}

variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this module"
  default     = "debian"
}

variable "machine_number" {
  type        = string
  description = "unique machine number to be a suffix to the overall machine name and resource group"
}