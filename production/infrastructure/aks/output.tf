output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
