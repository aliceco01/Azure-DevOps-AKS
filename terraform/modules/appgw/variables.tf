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

variable "ssl_certificate_password" {
  description = "The password for the SSL certificate"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}