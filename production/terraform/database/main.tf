# PostgreSQL Flexible Server in Central India
resource "azurerm_postgresql_flexible_server" "maksprimarydb" {
  name                   = "maksprimarydb"
  resource_group_name    = var.rg_names[2]
  location               = var.rg_location[2]
  version                = "14"
  administrator_login    = "pgadmin"
  administrator_password = "Password123"
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  zone                   = "1"
  backup_retention_days  = 7

  delegated_subnet_id    = var.subnet3_id[2]
  public_network_access_enabled = false
  private_dns_zone_id    = azurerm_private_dns_zone.pg_dns_zone.id
}


/**
# PostgreSQL Read Replica in USEast
resource "azurerm_postgresql_flexible_server" "replica_useast" {
  name                    = "maksreplicauseast"
  resource_group_name     = var.rg_names[0]
  location                = var.rg_location[0]
  create_mode             = "Replica"
  source_server_id        = azurerm_postgresql_flexible_server.maksprimarydb.id
  delegated_subnet_id     = var.subnet3_id[0]
  private_dns_zone_id     = azurerm_private_dns_zone.pg_dns_zone.id
}
**/

# PostgreSQL Read Replica in UKWest
resource "azurerm_postgresql_flexible_server" "replica_ukwest" {
  name                    = "maksreplicaukwest"
  resource_group_name     = var.rg_names[1]
  location                = var.rg_location[1]
  create_mode             = "Replica"
  source_server_id        = azurerm_postgresql_flexible_server.maksprimarydb.id
  delegated_subnet_id     = var.subnet3_id[1]
  private_dns_zone_id     = azurerm_private_dns_zone.pg_dns_zone.id
  public_network_access_enabled = false
}


# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "pg_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.rg_names[2]
}


# Link Private DNS Zone to VNets
resource "azurerm_private_dns_zone_virtual_network_link" "link_centralindia" {
  name                  = "centralindia-link"
  resource_group_name   = var.rg_names[2]
  private_dns_zone_name = azurerm_private_dns_zone.pg_dns_zone.name
  virtual_network_id    = var.vnet_id[2]
}

/**
resource "azurerm_private_dns_zone_virtual_network_link" "link_useast" {
  name                  = "useast-link"
  resource_group_name   = var.rg_names[2]
  private_dns_zone_name = azurerm_private_dns_zone.pg_dns_zone.name
  virtual_network_id    = var.vnet_id[0]
}
**/

resource "azurerm_private_dns_zone_virtual_network_link" "link_ukwest" {
  name                  = "ukwest-link"
  resource_group_name   = var.rg_names[2]
  private_dns_zone_name = azurerm_private_dns_zone.pg_dns_zone.name
  virtual_network_id    = var.vnet_id[1]
}
