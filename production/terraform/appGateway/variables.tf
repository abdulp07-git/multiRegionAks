  variable "rg_names" {
    type = list(string)
  }

  variable "rg_location" {
    type = list(string)
  }

  variable "vnet_id" {
    type = list(string)
  }

  variable "subnet2_id" {
    type = list(string)
  }

  variable "backend" {
    type = list(string)
    default = [ 
        "10.0.0.63",
        "10.1.0.63",
        "10.2.0.64"
         ]
  }

variable "region" {
  description = "Regions in which the cluster is created"  
  type = list(string)
  default = [ "eastus", "ukwest", "centralindia" ]
}

variable "hostname" {
  type = string
  default = "maven.intodepth.in"
}
