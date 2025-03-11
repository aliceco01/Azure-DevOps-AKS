# terraform/modules/aks/variables.tf
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

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the node pools"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
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

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR for AKS"
  type        = string
  default     = "172.17.0.1/16"
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling for node pools"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum number of nodes for auto-scaling"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum number of nodes for auto-scaling"
  type        = number
  default     = 3
}

variable "os_disk_size_gb" {
  description = "OS disk size for nodes in GB"
  type        = number
  default     = 50
}

variable "os_disk_type" {
  description = "OS disk type for nodes"
  type        = string
  default     = "Managed"
}

variable "enable_defender" {
  description = "Enable Microsoft Defender for Containers"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = null
}

variable "log_analytics_sku" {
  description = "SKU of the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}

variable "aad_tenant_id" {
  description = "Azure AD tenant ID for AKS RBAC"
  type        = string
  default     = null
}

variable "aad_admin_group_object_ids" {
  description = "Object IDs of Azure AD groups with admin access"
  type        = list(string)
  default     = null
}

variable "maintenance_window_enabled" {
  description = "Enable maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window_day" {
  description = "Day of maintenance window"
  type        = string
  default     = "Sunday"
}

variable "maintenance_window_hours" {
  description = "Hours for maintenance window"
  type        = list(number)
  default     = [0, 1, 2]
}

variable "automatic_channel_upgrade" {
  description = "The upgrade channel for AKS"
  type        = string
  default     = "stable"
}

variable "tags" {
  description = "Tags for AKS resources"
  type        = map(string)
  default     = {}
}