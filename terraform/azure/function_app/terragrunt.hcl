locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "${path_relative_from_include()}//modules/function_app"
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

dependency "storage_account" {
  config_path = "../storage_account"
  mock_outputs = {
    storage_account_name = "mockname"
    storage_account_access_key = "mock_primary_access_key"
    storage_account_primary_connection_string = "mock_connection_string"
  }
}

inputs = {
  primary_location = local.env.primary_location
  primary_location_abbr = local.env.primary_location_abbr

  logging_location = local.env.logging_location
  logging_location_abbr = local.env.logging_location_abbr

  project_group = local.env.project_group
  project_name = local.env.project_name
  project_env = local.env.project_env

  network_tiers = local.env.network_tiers

  tags = merge(local.env.env_tags, {})

  rg_name = dependency.resource_group.outputs.all_rg_names[0]

  storage_account_name = dependency.storage_account.outputs.storage_account_name
  storage_account_access_key = dependency.storage_account.outputs.storage_account_access_key
  storage_account_primary_connection_string = dependency.storage_account.outputs.storage_account_primary_connection_string
}