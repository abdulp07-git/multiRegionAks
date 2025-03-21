
/**
variable "private_dns_zone" {
  type = list(string)
  default = [ 
    "181a9394-a08b-45a2-a58a-9a3f017abf4c.privatelink.eastus.azmk8s.io",
    "ab9f43b1-1969-4be7-9150-cee59e8a7be1.privatelink.ukwest.azmk8s.io",
    "18dcfbdd-6e1b-41b0-a06a-479d56f96a2b.privatelink.centralindia.azmk8s.io" 
  ]
}
**/

variable "private-fqdn" {
  type = list(string)
}

variable "private_dns_rg" {
  type = list(string)
  default = [ 
    "mc_pro-eastus_maks-pro-eastus_eastus",
    "mc_pro-ukwest_maks-pro-ukwest_ukwest",
    "mc_pro-centralindia_maks-pro-centralindia_centralindia" 
    ]
}


variable "vnet_id" {
  type = list(string)
}





