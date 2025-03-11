# terraform/modules/appgw/variables.tf
variable "appgw_name" {
  description = "Name of the Application Gateway"
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

variable "appgw_subnet_id" {
  description = "Subnet ID for the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name of the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "SKU tier of the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "capacity" {
  description = "Capacity of the Application Gateway"
  type        = number
  default     = 2
}

variable "enable_private_frontend" {
  description = "Enable private frontend IP"
  type        = bool
  default     = false
}

variable "ssl_certificate_name" {
  description = "Name of the SSL certificate"
  type        = string
  default     = null
}

variable "key_vault_secret_id" {
  description = "Key Vault secret ID for SSL certificate"
  type        = string
  default     = null
}

variable "waf_mode" {
  description = "WAF mode (Detection or Prevention)"
  type        = string
  default     = "Prevention"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostics"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}