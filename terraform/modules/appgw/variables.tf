variable "appgw_name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "appgw_subnet_id" {
  description = "The ID of the Application Gateway subnet"
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault storing the SSL certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}


variable "ssl_certificate_secret_id" {
  description = "The secret ID of the SSL certificate stored in Azure Key Vault"
  type        = string
}

