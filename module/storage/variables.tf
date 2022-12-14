variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this module"
  default     = "stg"
}

variable "network_id" {
  type        = string
  description = "The virtual network for the storage account"
}

variable "subnet_id" {
  type        = string
  description = "The Subnet the storage is added to"
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