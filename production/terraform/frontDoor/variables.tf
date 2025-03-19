variable "gateway-ips" {
  type = list(string)
}

variable "afd-rg" {
  type = string
  default = "pro-centralindia"
}

variable "afd-domain-name" {
  type = string
  
}

