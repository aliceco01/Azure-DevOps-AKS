variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-aks-devops"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "aks-subnet"
}

variable "address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "acr_name" {
  description = "The name of the ACR"
  type        = string
  default     = "myacrdevops"
}

variable "sku" {
  description = "The SKU of the ACR"
  type        = string
  default     = "Standard"
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "The size of the VMs in the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "service_cidr" {
  description = "The CIDR for the Kubernetes service network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "The IP address of the DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "The CIDR for the Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "aks-devops"
  }
}
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}
