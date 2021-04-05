output "ssh_command" {
  value = "ssh ${module.jumpbox.jumpbox_username}@${module.jumpbox.jumpbox_ip}"
}

output "jumpbox_password" {
  description = "Jumpbox Admin Passowrd"
  value       = module.jumpbox.jumpbox_password
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.privateaks.name
  
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.privateaks.kube_config_raw
}