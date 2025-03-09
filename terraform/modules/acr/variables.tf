
variable "acr_name" {
  description = "The name of the ACR"
  type        = string
}

variable "location" {
  description = "The location of the ACR"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku" {
  description = "The SKU of the ACR"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}