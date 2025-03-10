
variable "acr_name" {
  description = "The name of the ACR"
  type        = string
  default = "myacrdevops"
}

variable "location" {
  description = "The location of the ACR"
  type        = string
  default = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default = "rg-aks-devops"
}

variable "sku" {
  description = "The SKU of the ACR"
  type        = string
  default = "Standard"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}