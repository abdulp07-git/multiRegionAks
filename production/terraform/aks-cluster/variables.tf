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
}

variable "default_node_pool_count" {
  type = number
  
}


variable "worker_node_pool_size" {
  type = string
  
}

variable "worker_node_pool_count" {
  type = number
  
}

variable "region" {
  description = "Regions in which the cluster is created"  
  type = list(string)
  
}


