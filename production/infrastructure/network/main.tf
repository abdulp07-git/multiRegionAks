resource "azurerm_resource_group" "rg" {
  location = var.location
  name = var.rgname
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnetname
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [var.cidr]

}

resource "azurerm_subnet" "subnet" {
  name = var.subnetname
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnetiprange]
}

resource "azurerm_subnet" "subnet2" {
  name = var.subnetname2
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnetgatewayrange]
}

resource "azurerm_network_security_group" "nsg" {
  name = "bw-nsg"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.security-rule
    content {
      name = security_rule.value.name
      priority = security_rule.value.priority
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = security_rule.value.destination_port
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
  }
}


resource "azurerm_public_ip" "public_ip" {
  name = "public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"

}

resource "azurerm_network_interface" "bw_nic" {
  name = "bw_nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_subnet_network_security_group_association" "bw_subnet_nsg_association" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_subnet_network_security_group_association" "bw_subnet_nsg_association2" {
  subnet_id = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}



resource "azurerm_network_interface_security_group_association" "bw_nic_nsg_association" {
  network_interface_id = azurerm_network_interface.bw_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}



resource "azurerm_linux_virtual_machine" "bwnginxvm" {
  name = "bwnginxvm"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  size = "Standard_B1s"
  admin_username = "azureuser"
  network_interface_ids = [azurerm_network_interface.bw_nic.id]

  admin_ssh_key {
    username = "azureuser"
    #public_key = file("~/.ssh/gatewayKey.pub")
    public_key = var.ssh-key
    
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    

  }

  source_image_id = "/subscriptions/82e6f7b9-feb5-4db0-9115-0528fa4ad1c7/resourceGroups/generalRG/providers/Microsoft.Compute/images/aks-gateway-image"

}
