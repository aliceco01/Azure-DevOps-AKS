variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "aks_subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR for AKS"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
}

variable "tags" {
  description = "Tags for AKS resources"
  type        = map(string)
  default     = {}
}