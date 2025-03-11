terraform {
  backend "azurerm" {
    resource_group_name   = "your-resource-group"
    storage_account_name  = "yourstorageaccount"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}