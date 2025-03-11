resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "exampleact"

  email_receiver {
    name = "sendtoadmin"
    email_address = "satyapanuganti@gmail.com"
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metricalert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when CPU is greater than 60."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60
    # when Average CPU > 60 for 5 min(default)

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "disk" {
  name                = "example-metricalert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when Free disk space is less than 20."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 20
    # when Available Memory Bytes < 20 for 5 min(default)

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "memory" {
  name                = "memory-metricalert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when Memory is less than 20."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Percentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 20

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "disklatency" {
  name                = "disklatency-metricalert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when Disk Latency is more than 1 Min."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Data Disk Latency"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60000

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "netout" {
  name                = "netout-metricalert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when Network Out is more than 100 MB."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Network Out Total"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 100000000

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "netin" {
  name                = "netin-metricalert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id]
  description         = "Action will be triggered when Network In is more than 100 MB."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Network In Total"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 100000000

  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
