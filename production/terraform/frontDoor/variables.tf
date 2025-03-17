variable "gateway-ips" {
  type = list(string)
}

variable "afd-rg" {
  type = string
  default = "rg-centralindia"
}

variable "domain-name" {
  default = "maven.intodepth.in"
}

