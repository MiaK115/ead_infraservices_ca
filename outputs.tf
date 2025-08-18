output "rg"  { value = azurerm_resource_group.rg.name }
output "aks" { value = azurerm_kubernetes_cluster.aks.name }
output "acr" { value = azurerm_container_registry.acr.name }