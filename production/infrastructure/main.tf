provider "azurerm" {
  features {
    
  }
  subscription_id = "82e6f7b9-feb5-4db0-9115-0528fa4ad1c7"
}

terraform {
  backend "azurerm" {
    subscription_id      = "82e6f7b9-feb5-4db0-9115-0528fa4ad1c7"
    resource_group_name = "generalRG"
    storage_account_name = "abdbackends"
    container_name = "multiaks"
    key = "terraform.tfstate"
  }
}


module "network" {
  source = "./network"
}

module "aks-cluster" {
  source = "./aks-cluster"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
  vnet_id = module.network.vnet_id
  subnet1_id = module.network.subnet1_id
}

module "gateway" {
  source = "./appGateway"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
  vnet_id = module.network.vnet_id
  subnet2_id = module.network.subnet2_id
}

module "frontDoor" {
  source = "./frontDoor"
  gateway-ips = module.gateway.gateway-ips
}
