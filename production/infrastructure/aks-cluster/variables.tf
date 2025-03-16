variable "rg_names" {
  type = list(string)
}


variable "rg_location" {
  type = list(string)
}

variable "vnet_id" {
  type = list(string)
}

variable "subnet1_id" {
  type = list(string)
}

variable "acr-name" {
  type = string
  default = "maksacr"
}

variable "dns_prefix" {
  type = string
  default = "prodns"
}

variable "default_node_pool_size" {
  type = string
  default = "Standard_DS2_v2"
}

variable "default_node_pool_count" {
  type = number
  default = 1
}


variable "worker_node_pool_size" {
  type = string
  default = "Standard_A2m_v2"
}

variable "worker_node_pool_count" {
  type = number
  default = 1
}

variable "region" {
  description = "Regions in which the cluster is created"  
  type = list(string)
  default = [ "eastus", "ukwest", "centralindia" ]
}


variable "private_dns_zone" {
  type = list(string)
  default = [ 
    "5427b209-d106-43a4-8e6f-741c8a94ee0a.privatelink.eastus.azmk8s.io",
    "6424c437-9aae-4848-904c-25318e389a0a.privatelink.ukwest.azmk8s.io",
    "0c17413c-97c8-47c1-96ab-dc0ab3f5b491.privatelink.centralindia.azmk8s.io" 
  ]
}

variable "private_dns_rg" {
  type = list(string)
  default = [ 
    "mc_rg-eastus_maks-rg-eastus_eastus",
    "mc_rg-ukwest_maks-rg-ukwest_ukwest",
    "mc_rg-centralindia_maks-rg-centralindia_centralindia" 
    ]
}
