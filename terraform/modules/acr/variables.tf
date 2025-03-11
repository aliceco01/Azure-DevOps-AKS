# terraform/modules/acr/variables.tf
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
  default     = "Standard"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}

variable "aks_subnet_id" {
  description = "The ID of the AKS subnet for network rules"
  type        = string
  default     = null
}

variable "allowed_cidr_block" {
  description = "CIDR block for IP-based access control"
  type        = string
  default     = "0.0.0.0/0"  # Allow all by default, should be restricted in production
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key for encryption"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for diagnostics"
  type        = string
  default     = null
}