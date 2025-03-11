
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "aks_address_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
}

variable "appgw_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
}

variable "appgw_address_prefixes" {
  description = "Address prefixes for the Application Gateway subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}