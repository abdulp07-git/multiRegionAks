output "postgres_master_endpoint" {
    value       = azurerm_postgresql_flexible_server.maksprimarydb.fqdn
}



output "postgres_replica_ukwest_endpoint" {
    value       = azurerm_postgresql_flexible_server.replica_ukwest.fqdn
}


/**
output "postgres_replica_useast_endpoint" {
    value       = azurerm_postgresql_flexible_server.replica_useast.fqdn
}
*/
