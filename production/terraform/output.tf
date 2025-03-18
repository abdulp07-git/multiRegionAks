
output "bastio-ip" {
  value = module.network.bastion-ip
}

output "acr-name" {
  value = module.acr.acr-name
}




output "gateway-ips" {
  value = module.gateway.gateway-ips
}


output "afd-cname" {
  value = module.frontDoor.afd-cname
}



output "private-fqdn" {
  value = module.aks-cluster.private-fqdn
}

output "private_dns_zones" {
  value = module.pvt-dns-zone.private_dns_zones
}
