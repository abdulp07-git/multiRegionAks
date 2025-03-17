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

variable "acr-id" {
  type = string
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


