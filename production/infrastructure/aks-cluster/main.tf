/*ACR in Central India*/

resource "azurerm_container_registry" "maks-acr" {
  name = var.acr-name
  resource_group_name = var.rg_names[2]
  location = var.rg_location[2]
  sku = "Basic"
  admin_enabled = false
}



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
    azure_rbac_enabled = true

  }

  tags = {
    environment = "production"
  }

  depends_on = [ 
    azurerm_container_registry.maks-acr,

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
  scope = azurerm_container_registry.maks-acr.id
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



/* Link private DNS zone with vnet   "eastus", "ukwest", "centralindia" **/



/* eastus with ukwest */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-ukwest" {
  name = "dnslink-eastus-ukwest"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = var.private_dns_zone[0]
  virtual_network_id = var.vnet_id[1]
}

/* eastus with centralindia */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-centralindia" {
  name = "dnslink-eastus-centralindia"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = var.private_dns_zone[0]
  virtual_network_id = var.vnet_id[2]
}


/* ukwest with eastus */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-eastus" {
  name = "dnslink-ukwest-eastus"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = var.private_dns_zone[1]
  virtual_network_id = var.vnet_id[0]
}

/* ukwest with centralindia */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-centralindia" {
  name = "dnslink-ukwest-centralindia"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = var.private_dns_zone[1]
  virtual_network_id = var.vnet_id[2]
}


/* centralindia with eastus */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-eastus" {
  name = "dnslink-centralindia-eastus"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = var.private_dns_zone[2]
  virtual_network_id = var.vnet_id[0]
}


/* centralindia with ukwest */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-ukwest" {
  name = "dnslink-centralindia-ukwest"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = var.private_dns_zone[2]
  virtual_network_id = var.vnet_id[1]
}


