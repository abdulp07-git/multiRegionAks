
output "bastio-ip" {
  value = module.network.bastion-ip
}

output "gateway-ips" {
  value = module.gateway.gateway-ips
}


output "afd-cname" {
  value = module.frontDoor.afd-cname
}
