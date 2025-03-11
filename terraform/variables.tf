
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-aks-devops"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "aks-devops"
    provisioner = "terraform"
  }
}

# ACR Variables
variable "acr_name" {
  description = "The name of the Azure Container Registry (without random suffix)"
  type        = string
  default     = "acraksdevops"
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
  default     = "Standard"
}

# Network Variables
variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  default     = "vnet-aks"
}

variable "address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "snet-aks"
}

variable "aks_address_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "appgw_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
  default     = "snet-appgw"
}

variable "appgw_address_prefixes" {
  description = "Address prefixes for the Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# AKS Variables
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes"
  type        = string
  default     = "1.26.6"
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The size of the VMs in the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "os_disk_size_gb" {
  description = "The OS disk size in GB for AKS nodes"
  type        = number
  default     = 50
}

variable "os_disk_type" {
  description = "The OS disk type for AKS nodes"
  type        = string
  default     = "Managed"
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling for the default node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "The minimum number of nodes for auto-scaling"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "The maximum number of nodes for auto-scaling"
  type        = number
  default     = 3
}

variable "service_cidr" {
  description = "The CIDR for the Kubernetes service network"
  type        = string
  default     = "10.0.3.0/24"
}

variable "dns_service_ip" {
  description = "The IP address of the DNS service"
  type        = string
  default     = "10.0.3.10"
}

variable "docker_bridge_cidr" {
  description = "The CIDR for the Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

# App Gateway Variables
variable "appgw_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "appgw-aks"
}

variable "appgw_sku_name" {
  description = "The SKU name of the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "appgw_sku_tier" {
  description = "The SKU tier of the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "appgw_capacity" {
  description = "The capacity of the Application Gateway"
  type        = number
  default     = 2
}

# Log Analytics Variables
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "log-aks"
}

variable "log_analytics_sku" {
  description = "The SKU of the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period in days for logs"
  type        = number
  default     = 30
}