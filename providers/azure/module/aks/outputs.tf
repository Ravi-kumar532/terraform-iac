output "id" {

  value = azurerm_kubernetes_cluster.this.id

}

output "name" {

  value = azurerm_kubernetes_cluster.this.name

}

output "identity_principal_id" {

  value = azurerm_kubernetes_cluster.this.identity[0].principal_id

}
