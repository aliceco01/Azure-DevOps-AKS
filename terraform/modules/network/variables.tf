variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "The name of the AKS subnet"
  type        = string
}

variable "aks_subnet_prefix" {
  description = "The address prefix of the AKS subnet"
  type        = string
}

variable "appgw_subnet_name" {
  description = "The name of the Application Gateway subnet"
  type        = string
}

variable "appgw_subnet_prefix" {
  description = "The address prefix of the Application Gateway subnet"
  type        = string
}