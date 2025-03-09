terraform {
  backend "azurerm" {
    resource_group_name  = "rg-aks-devops"
    storage_account_name = "mytfstatealice"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
