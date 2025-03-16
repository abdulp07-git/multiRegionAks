
/* RG all 3 region */

resource "azurerm_resource_group" "rg" {
  count = length(var.region)
  location = var.region[count.index]
  name = "rg-${var.region[count.index]}"
}


/* VNET all three regions */

resource "azurerm_virtual_network" "vnet" {
  count = length(var.region)
  name = "vnet-${azurerm_resource_group.rg[count.index].name}"
  location = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name
  address_space = ["10.${count.index}.0.0/16"]
}

/* Subnet1 all three region*/

resource "azurerm_subnet" "subnet1" {
  count = length(var.region)
  name = "subnet1-${var.region[count.index]}"
  resource_group_name = azurerm_resource_group.rg[count.index].name 
  virtual_network_name = azurerm_virtual_network.vnet[count.index].name
  address_prefixes = ["10.${count.index}.0.0/19"]
}


/* Subnet2 all three region*/

resource "azurerm_subnet" "subnet2" {
  count = length(var.region)
  name = "subnet2-${var.region[count.index]}"
  resource_group_name = azurerm_resource_group.rg[count.index].name 
  virtual_network_name = azurerm_virtual_network.vnet[count.index].name
  address_prefixes = ["10.${count.index}.32.0/19"]
}


/*NSG all three region*/

resource "azurerm_network_security_group" "nsg" {
  count = length(var.region)
  name = "nsg-${var.region[count.index]}"
  location = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name
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


/*Subnet1 NSG association in all three region*/

resource "azurerm_subnet_network_security_group_association" "sub1-nsg" {
    count = length(var.region)
    subnet_id = azurerm_subnet.subnet1[count.index].id
    network_security_group_id = azurerm_network_security_group.nsg[count.index].id
 
}


/*Subnet2 NSG association in all three region*/

resource "azurerm_subnet_network_security_group_association" "sub2-nsg" {
    count = length(var.region)
    subnet_id = azurerm_subnet.subnet2[count.index].id
    network_security_group_id = azurerm_network_security_group.nsg[count.index].id
 
}



/*Cross region VNET peering  "eastus", "ukwest", "centralindia"  START **/


/*   Peering eastus -  ukwest  */

resource "azurerm_virtual_network_peering" "eastus_ukwest" {
  name = "eastus_ukwest"
  resource_group_name = azurerm_resource_group.rg[0].name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[1].id
  allow_virtual_network_access = true
 
}

/*   Peering ukwest -  eastus  */

resource "azurerm_virtual_network_peering" "ukwest_eastus" {
  name = "ukwest_eastus"
  resource_group_name = azurerm_resource_group.rg[1].name
  virtual_network_name = azurerm_virtual_network.vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[0].id
  allow_virtual_network_access = true
 
}

/*   Peering eastus -  centralindia  */

resource "azurerm_virtual_network_peering" "eastus_centralindia" {
  name = "eastus_centralindia"
  resource_group_name = azurerm_resource_group.rg[0].name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[2].id
  allow_virtual_network_access = true
 
}


/*   Peering centralindia -  eastus  */

resource "azurerm_virtual_network_peering" "centralindia_eastus" {
  name = "centralindia_eastus"
  resource_group_name = azurerm_resource_group.rg[2].name
  virtual_network_name = azurerm_virtual_network.vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[0].id
  allow_virtual_network_access = true
 
}


/*   Peering ukwest -  centralindia  */

resource "azurerm_virtual_network_peering" "ukwest_centralindia" {
  name = "ukwest_centralindia"
  resource_group_name = azurerm_resource_group.rg[1].name
  virtual_network_name = azurerm_virtual_network.vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[2].id
  allow_virtual_network_access = true
 
}


/*   Peering centralindia -  ukwest  */

resource "azurerm_virtual_network_peering" "centralindia_ukwest" {
  name = "centralindia_ukwest"
  resource_group_name = azurerm_resource_group.rg[2].name
  virtual_network_name = azurerm_virtual_network.vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[1].id
  allow_virtual_network_access = true
 
}



/*************    PEERING ENDS  **********************/





/******************BASTION HOST ******************/

/* Public IP for bastion server in CentralIndia */

resource "azurerm_public_ip" "bastionIP" {
  name = var.bastionIP
  resource_group_name = azurerm_resource_group.rg[2].name
  location = azurerm_resource_group.rg[2].location
  allocation_method = "Static"
}

/*NIC for bastion host*/

resource "azurerm_network_interface" "bastionNIC" {
  name = "bastionNIC"
  location = azurerm_resource_group.rg[2].location
  resource_group_name = azurerm_resource_group.rg[2].name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet1[2].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.bastionIP.id
  }
}


/* Associate NIC with NSG*/

resource "azurerm_network_interface_security_group_association" "NicNsg" {
  network_interface_id = azurerm_network_interface.bastionNIC.id
  network_security_group_id = azurerm_network_security_group.nsg[2].id
}


/*Bastion host in Central India region*/

resource "azurerm_linux_virtual_machine" "bastion" {
  name = "bastion"
  resource_group_name = azurerm_resource_group.rg[2].name
  location = azurerm_resource_group.rg[2].location
  size = var.vmsize
  admin_username = "azureuser"
  network_interface_ids = [ azurerm_network_interface.bastionNIC.id ]

  admin_ssh_key {
    username = "azureuser"
    public_key = var.ssh-key
    
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"  

  }

  source_image_id = "/subscriptions/82e6f7b9-feb5-4db0-9115-0528fa4ad1c7/resourceGroups/generalRG/providers/Microsoft.Compute/images/bastion-image"

}


/******************BASTION HOST END  ******************/
