output "afd-cname" {
  value = azurerm_frontdoor.afd.frontend_endpoint[0].host_name
}
