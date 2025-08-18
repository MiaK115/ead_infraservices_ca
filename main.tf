resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
}

resource "random_integer" "rand" {
  min = 1000
  max = 9999
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.name_prefix}acr${random_integer.rand.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.name_prefix}-dns"

  default_node_pool {
    name       = "nodepool1"
    node_count = 2 # reduced to fit vCPU quota
    vm_size    = "Standard_B2ms"
  }

  identity { type = "SystemAssigned" }
  role_based_access_control_enabled = true
}

resource "azurerm_role_assignment" "aks_pull_acr" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
