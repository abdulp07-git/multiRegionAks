
# Extract the private DNS zones dynamically


locals {
  private_dns_zones = [for fqdn in var.private-fqdn : join(".", slice(split(".", fqdn), 1, length(split(".", fqdn))))]
}


/* eastus with ukwest */
resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-ukwest" {
  name = "dnslink-eastus-ukwest"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = local.private_dns_zones[0]
  virtual_network_id = var.vnet_id[1]
}

/* eastus with centralindia */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-centralindia" {
  name = "dnslink-eastus-centralindia"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = local.private_dns_zones[0]
  virtual_network_id = var.vnet_id[2]
}


/* ukwest with eastus */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-eastus" {
  name = "dnslink-ukwest-eastus"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = local.private_dns_zones[1]
  virtual_network_id = var.vnet_id[0]
}


/* ukwest with centralindia */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-centralindia" {
  name = "dnslink-ukwest-centralindia"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = local.private_dns_zones[1]
  virtual_network_id = var.vnet_id[2]
}


/* centralindia with eastus */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-eastus" {
  name = "dnslink-centralindia-eastus"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = local.private_dns_zones[2]
  virtual_network_id = var.vnet_id[0]
}


/* centralindia with ukwest */

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-ukwest" {
  name = "dnslink-centralindia-ukwest"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = local.private_dns_zones[2]
  virtual_network_id = var.vnet_id[1]
}






/**

/* Link private DNS zone with vnet   "eastus", "ukwest", "centralindia" **/



/* eastus with ukwest 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-ukwest" {
  name = "dnslink-eastus-ukwest"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = var.private_dns_zone[0]
  virtual_network_id = var.vnet_id[1]
}

/* eastus with centralindia 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-eastus-centralindia" {
  name = "dnslink-eastus-centralindia"
  resource_group_name = var.private_dns_rg[0]
  private_dns_zone_name = var.private_dns_zone[0]
  virtual_network_id = var.vnet_id[2]
}


/* ukwest with eastus 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-eastus" {
  name = "dnslink-ukwest-eastus"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = var.private_dns_zone[1]
  virtual_network_id = var.vnet_id[0]
}

/* ukwest with centralindia 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-ukwest-centralindia" {
  name = "dnslink-ukwest-centralindia"
  resource_group_name = var.private_dns_rg[1]
  private_dns_zone_name = var.private_dns_zone[1]
  virtual_network_id = var.vnet_id[2]
}


/* centralindia with eastus 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-eastus" {
  name = "dnslink-centralindia-eastus"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = var.private_dns_zone[2]
  virtual_network_id = var.vnet_id[0]
}


/* centralindia with ukwest 

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink-centralindia-ukwest" {
  name = "dnslink-centralindia-ukwest"
  resource_group_name = var.private_dns_rg[2]
  private_dns_zone_name = var.private_dns_zone[2]
  virtual_network_id = var.vnet_id[1]
}


*/
