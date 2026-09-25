# terraform/monitoring.tf
# Additive resource -- does not touch resource_group.tf or kubernetes_serivce.tf directly.
# Adds a Log Analytics workspace + Container Insights solution for the existing AKS cluster.

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "law-sit722-wk8-572189"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.monitoring.id
  workspace_name        = azurerm_log_analytics_workspace.monitoring.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.monitoring.id
}
