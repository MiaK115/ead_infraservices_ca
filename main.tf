resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.name_prefix}-dns"

  default_node_pool {
    name       = "nodepool1"
    node_count = 1            # was 2
    vm_size    = "Standard_B4ms"
  }

  identity { type = "SystemAssigned" }
  role_based_access_control_enabled = true
}