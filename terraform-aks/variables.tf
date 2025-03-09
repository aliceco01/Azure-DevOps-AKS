variable "resource_group_name" {
  description = "The name of the Azure Resource Group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the resources."
  type        = string
  default     = "East US"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the AKS cluster."
  type        = string
  default     = "1.26.3"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster."
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "The size of the VM instances for the nodes in the AKS cluster."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "network_plugin" {
  description = "The network plugin to use for networking in the AKS cluster."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "The network policy to use for networking in the AKS cluster."
  type        = string
  default     = "azure"
}

variable "dns_prefix" {
  description = "The DNS prefix to use for the AKS cluster."
  type        = string
  default     = "aks-${random_string.suffix.result}"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "vnet_cidr" {
  description = "The CIDR block for the Virtual Network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the AKS subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_cluster_enabled" {
  description = "Enable private cluster mode for AKS."
  type        = bool
  default     = true
}

variable "ingress_controller_enabled" {
  description = "Enable NGINX ingress controller."
  type        = bool
  default     = true
}

variable "enable_rbac" {
  description = "Enable Role-Based Access Control (RBAC) in AKS."
  type        = bool
  default     = true
}
