locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "git::https://github.com/andygodish/terraform-modules-azure-storageaccount.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    all_rg_names = ["mock_name2"]
  }
}


inputs = {
  primary_location = local.env.primary_location
  primary_location_abbr = local.env.primary_location_abbr

  project_group = local.env.project_group
  project_name = local.env.project_name
  project_env = local.env.project_env 

  public_network_access_enabled = local.env.public_network_access_enabled

  tags = merge(local.env.env_tags, {})

  rg_name = dependency.resource_group.outputs.all_rg_names[0]
}