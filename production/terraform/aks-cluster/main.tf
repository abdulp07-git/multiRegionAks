
/*  Kubernetes cluster in all three region */

resource "azurerm_kubernetes_cluster" "maks" {
  count = length(var.rg_names)
  name = "maks-${var.rg_names[count.index]}"
  location = var.rg_location[count.index]
  resource_group_name = var.rg_names[count.index]
  dns_prefix = "maksdns"
  private_cluster_enabled = true

  default_node_pool {
    name = "system"
    node_count = var.default_node_pool_count
    vm_size = var.default_node_pool_size
    vnet_subnet_id = var.subnet1_id[count.index]
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr = "10.5.0.0/16"
    dns_service_ip = "10.5.0.10"
  }

  

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [ "9be1221b-68f2-4a2a-a1bd-36361f39a6d6" ]
    azure_rbac_enabled = false
  }

  tags = {
    environment = "production"
  }

  depends_on = [ 
    var.acr-id

  ]
}


/* Worker node pool for cluster */

resource "azurerm_kubernetes_cluster_node_pool" "Worker" {
  count = length(var.rg_names)
  name = "worker"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.maks[count.index].id 
  vm_size = var.worker_node_pool_size
  node_count = var.worker_node_pool_count
  mode = "User"
  temporary_name_for_rotation = "temppool1"
  vnet_subnet_id = var.subnet1_id[count.index]
}


/* ACR_PULL role assignemnt for the cluster*/

resource "azurerm_role_assignment" "acrpull" {
  count = length(var.rg_names)
  scope = var.acr-id
  role_definition_name = "AcrPull"
  principal_id = azurerm_kubernetes_cluster.maks[count.index].kubelet_identity[0].object_id
}


# Assign Network Contributor role to AKS system-assigned identity
resource "azurerm_role_assignment" "network_contributor" {
  count = length(var.rg_names)
  scope                = var.vnet_id[count.index]   # Ensure you pass the correct VNet ID as a variable
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.maks[count.index].identity[0].principal_id
}




