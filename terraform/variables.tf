variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default = "rg-aks-devops"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default = "East US"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default = "myacrdevops"
}

variable "sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
  default = "Standard"
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  default = "aks-vnet"
}

variable "address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "The size of the VMs in the default node pool"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR for the Kubernetes service network"
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address of the DNS service"
  type        = string
}

variable "docker_bridge_cidr" {
  description = "The CIDR for the Docker bridge network"
  type        = string
}

variable "appgw_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "aks-appgw"
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-subnet"
}

variable "aks_address_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "appgw_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
  default     = "appgw-subnet"
}

variable "appgw_address_prefixes" {
  description = "Address prefixes for the Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}