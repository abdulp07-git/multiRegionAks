resource "azurerm_container_registry" "acr" {
  name = "bw89acr"
  resource_group_name = var.rg
  location = var.location
  sku = "Basic"
  admin_enabled = false
}


resource "azurerm_kubernetes_cluster" "aks" {
  name = "bwaks"
  location = var.location
  resource_group_name = var.rg
  dns_prefix = "bwaksdns"
  private_cluster_enabled = true

  default_node_pool {
    name = "default"
    vm_size = "Standard_DS2_v2"
    node_count = 1
    vnet_subnet_id = var.subnet_id
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }

  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }

  depends_on = [ azurerm_container_registry.acr ]

  
}

resource "azurerm_kubernetes_cluster_node_pool" "worker" {
  name = "workerpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size = "Standard_A2m_v2"
  node_count = 1
  mode = "User"
  temporary_name_for_rotation = "temppool1" 
  vnet_subnet_id        = var.subnet_id

}


# Assign AcrPull role to AKS kubelet identity
resource "azurerm_role_assignment" "acrpull" {
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Assign Network Contributor role to AKS system-assigned identity
resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.vnet-id   # Ensure you pass the correct VNet ID as a variable
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
