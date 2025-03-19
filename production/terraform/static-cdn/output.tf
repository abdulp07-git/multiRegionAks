output "cdn_url" {
  value = "https://${azurerm_cdn_endpoint.makscdntoi.fqdn}"
}

output "blob_url" {
  value = "https://${azurerm_storage_account.maksstaticfiles.name}.blob.core.windows.net/${azurerm_storage_container.images.name}/"
}
