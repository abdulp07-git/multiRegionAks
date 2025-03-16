/* Test Outputs*/
output "rg" {
  value = { for index, rg in azurerm_resource_group.rg : rg.name => rg.location }
}

output "test" {
  value = { for index, test in azurerm_virtual_network.vnet: test.name => test.id }
}

output "bastion-ip" {
  value = azurerm_linux_virtual_machine.bastion.public_ip_address
}
/***********/



/* Resource group names as a list*/

output "rg_names" {
  value = [ for rg in azurerm_resource_group.rg : rg.name ]
}


/* Resource group location as a list*/
output "rg_location" {
  value =  [ for lc in azurerm_resource_group.rg : lc.location]
}


/* VNET id's as a list*/
output "vnet_id" {
  value = [ for vid in azurerm_virtual_network.vnet : vid.id ]
}

/*Subnet1 id's as a list*/
output "subnet1_id" {
  value = [ for sid in azurerm_subnet.subnet1 : sid.id]
}


output "subnet2_id" {
  value = [ for sid in azurerm_subnet.subnet2 : sid.id]
}

