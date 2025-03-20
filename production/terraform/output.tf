
output "bastio-ip" {
  value = module.network.bastion-ip
}

output "acr-name" {
  value = module.acr.acr-name
}


output "private-fqdn" {
  value = module.aks-cluster.private-fqdn
}


output "private_dns_zones" {
  value = module.pvt-dns-zone.private_dns_zones
}


output "gateway-ips" {
  value = module.gateway.gateway-ips
}

output "afd-cname" {
  value = module.frontDoor.afd-cname
}

output "cdn_url" {
  value = module.cdn.cdn_url
}

output "blob_url" {
  value = module.cdn.blob_url
}


output "postgres_master_endpoint" {
    value       = module.database.postgres_master_endpoint
}



output "postgres_replica_ukwest_endpoint" {
    value       = module.database.postgres_replica_ukwest_endpoint
}

/**
output "postgres_replica_useast_endpoint" {
    value       = module.database.postgres_replica_useast_endpoint
}
*/
