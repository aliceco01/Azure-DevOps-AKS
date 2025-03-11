variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the Kubernetes cluster"
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

variable "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  type        = string
}

variable "api_server_authorized_ip_ranges" {
  description = "The IP ranges authorized to access the API server"
  type        = list(string)
}

variable "rbac_enabled" {
  description = "Whether RBAC is enabled"
  type        = bool
}

variable "ingress_application_gateway_enabled" {
  description = "Whether the ingress application gateway is enabled"
  type        = bool
}

variable "appgw_name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "appgw_subnet_cidr" {
  description = "The CIDR block of the Application Gateway subnet"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the Linux profile"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for the Linux profile"
  type        = string
}

variable "client_id" {
  description = "The client ID for the service principal"
  type        = string
}

variable "client_secret" {
  description = "The client secret for the service principal"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}