
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


