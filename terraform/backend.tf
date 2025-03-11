
terraform {
  backend "azurerm" {
    # These values should be provided via environment variables or command line arguments
    # resource_group_name  = "tfstate"
    # storage_account_name = "tfstate"
    # container_name       = "tfstate"
    # key                  = "terraform.tfstate"
    # Do not hardcode these values, instead use:
    # terraform init \
    #   -backend-config="resource_group_name=your-resource-group" \
    #   -backend-config="storage_account_name=your-storage-account" \
    #   -backend-config="container_name=your-container" \
    #   -backend-config="key=your-key"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "random" {}