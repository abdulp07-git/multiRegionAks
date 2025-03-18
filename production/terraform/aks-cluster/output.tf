
output "private-fqdn" {
  value = [ for fqdn in azurerm_kubernetes_cluster.maks: fqdn.private_fqdn]
}
