variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this module"
  default     = "frw"
}

variable "subnet_id" {
  type        = string
  description = "The Subnet the firewall is added to"
}

variable "resource_group_name" {
    type = string
    description = "resource group name for the IP and firewall as they need to exist in the same resoruce group as the vnet"

}
variable "tags" {
  type        = map(any)
  description = "Tags to be added to the resources"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this module"
  default     = "eastus2"
}