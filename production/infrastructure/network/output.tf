output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.bwnginxvm.public_ip_address
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "vnet-name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet-id" {
  value = azurerm_subnet.subnet.id
}

output "subnet-gateway" {
  value = azurerm_subnet.subnet2.id
}
