output "resource_group" {
  value = module.network.resource_group_name
}

output "vmip" {
  value = module.network.vm_public_ip
}

output "aks_name" {
  value = module.aks.aks_name
}


#output "gateway-public-ip" {
  #value = module.gateway.gateway-public-ip
#}
