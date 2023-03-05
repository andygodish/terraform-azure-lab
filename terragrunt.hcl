locals {
  env = merge(
    // yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

# Use Terragrunt to generate your provider.tf file w the ability to inject variables
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
      
    }
  }
}  

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
EOF
}