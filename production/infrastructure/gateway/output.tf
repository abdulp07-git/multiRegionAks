output "gateway-public-ip" {
  value = azurerm_public_ip.appgw_pip.ip_address
}
