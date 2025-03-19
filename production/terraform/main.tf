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
  region = var.region
  rgname = var.rgname
}



module "acr" {
  source = "./acr"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
  acr-name = var.acr-name
  
}


module "aks-cluster" {
  source = "./aks-cluster"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
  vnet_id = module.network.vnet_id
  subnet1_id = module.network.subnet1_id
  acr-id = module.acr.acr-id
  region = var.region
  default_node_pool_size = var.default_node_pool_size
  default_node_pool_count = var.default_node_pool_count
  worker_node_pool_size = var.worker_node_pool_size
  worker_node_pool_count = var.worker_node_pool_count
}




module "pvt-dns-zone" {
  source = "./private-dns-zone"
  vnet_id = module.network.vnet_id
  private-fqdn = module.aks-cluster.private-fqdn
}



module "gateway" {
  source = "./appGateway"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
  vnet_id = module.network.vnet_id
  subnet2_id = module.network.subnet2_id
  backend = var.backend
  hostname = var.hostname
}


module "frontDoor" {
  source = "./frontDoor"
  gateway-ips = module.gateway.gateway-ips
  afd-domain-name = var.afd-domain-name
}


module "cdn" {
  source = "./static-cdn"
  rg_names = module.network.rg_names
  rg_location = module.network.rg_location
}


