locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "git::https://github.com/andygodish/terraform-modules-azure-resource-group.git?ref=v0.0.1"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  primary_location = local.env.primary_location
  primary_location_abbr = local.env.primary_location_abbr

  project_group = local.env.project_group
  project_name = local.env.project_name
  project_env = local.env.project_env

  network_tiers = local.env.network_tiers

  tags = merge(local.env.env_tags, {})
}