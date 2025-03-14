# Add logging and monitoring
resource "azurerm_log_analytics_workspace" "law" {
  name                      = "vmloganalytics"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  sku                       = "PerGB2018"
  retention_in_days         = 365
  internet_ingestion_enabled= true
  internet_query_enabled    = false
}

resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "vminsights"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}

#===================================================================
# Set Monitoring and Log Analytics Workspace
#===================================================================
resource "azurerm_virtual_machine_scale_set_extension" "oms_mma02" {
  name                          = "test-OMSExtension"
  virtual_machine_scale_set_id  =  azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
  publisher                     = "Microsoft.EnterpriseCloud.Monitoring"
  type                          = "OmsAgentForLinux"
  type_handler_version          = "1.12"
  auto_upgrade_minor_version    = true

  settings = <<SETTINGS
    {
      "workspaceId" : "${azurerm_log_analytics_workspace.law.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

