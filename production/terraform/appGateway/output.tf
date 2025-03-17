output "gateway-ips" {
  value = [ for ips in azurerm_public_ip.appgw-pip : ips.ip_address]
}
