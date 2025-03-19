variable "region" {
  type = list(string)
}

variable "rgname" {
  type = string
}

variable "acr-name" {
  type = string
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

variable "backend" {
  type = list(string)
}

variable "hostname" {
  type = string
}
variable "afd-domain-name" {
  type = string
}
