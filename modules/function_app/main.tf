resource "azurerm_service_plan" "app_service_plan" {
  resource_group_name = var.rg_name
  name                = "asp-${var.project_group}-${var.project_name}-${var.network_tiers[0]}-${var.project_env}-${var.primary_location_abbr}"
  os_type             = "Linux"
  location            = var.primary_location
  sku_name            = "B1"
}

##### Logging #####
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  resource_group_name = var.rg_name
  name                = "law-${var.project_group}-${var.project_name}-${var.network_tiers[0]}-${var.project_env}-${var.logging_location_abbr}"
  location            = var.logging_location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "application_insights" {
  resource_group_name = var.rg_name
  name                = "appin-${var.project_group}-${var.project_name}-${var.network_tiers[0]}-${var.project_env}-${var.logging_location_abbr}"
  location            = var.logging_location
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "web"
}
####### End #######

resource "azurerm_linux_function_app" "function_app" {
  resource_group_name = var.rg_name
  name                = "fa-${var.project_group}-${var.project_name}-${var.network_tiers[0]}-${var.project_env}-${var.primary_location_abbr}"
  location            = var.primary_location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  service_plan_id            = azurerm_service_plan.app_service_plan.id

  https_only = true

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.application_insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.application_insights.connection_string
    AzureWebJobsDashboard                 = var.storage_account_primary_connection_string
    AzureWebJobsStorage                   = var.storage_account_primary_connection_string
    FUNCTIONS_WORKER_RUNTIME              = var.functions_worker_runtime
    WEBSITE_PULL_IMAGE_OVER_VNET          = var.website_pull_image_over_vnet
  }

  site_config {}
}
