variable "private_dns_zone" {
  type = list(string)
  default = [ 
    "2958ad3c-126e-449e-991c-66e0d4d60407.privatelink.eastus.azmk8s.io",
    "93202369-02ea-4f5d-8f9a-c1d1695acf4e.privatelink.ukwest.azmk8s.io",
    "ac4894c2-b603-4534-b159-f17dd6d8f09e.privatelink.centralindia.azmk8s.io" 
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


variable "vnet_id" {
  type = list(string)
}





