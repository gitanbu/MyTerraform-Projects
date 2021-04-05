terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "e77ce59a-f934-42cc-a339-959b1a9c178a"
  tenant_id = "944e716a-bc17-4291-94c4-5e02fbcbccf7"
  skip_provider_registration = true
  features {}
}

