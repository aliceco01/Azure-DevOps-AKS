terraform {
  backend "azurerm" {
    resource_group_name   = "aks-pipeline-rg"
    storage_account_name  = "akspipelinestorage"
    container_name        = "terraform-state"
    key                   = "terraform.tfstate"
    
  }
}
