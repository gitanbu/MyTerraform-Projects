# Configure the Microsoft Azure Provider
# Create a resource group
resource "azurerm_resource_group" "shabackend" {
  name     = "shabackend"
  location = "southcentralus"
  
}

resource "azurerm_kubernetes_cluster" "shaapp" {
  name                = "azureshabackend"
  location            = azurerm_resource_group.shabackend.location
  resource_group_name = azurerm_resource_group.shabackend.name
  dns_prefix          = "azureshabackend"
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_F2s_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "d242dd07-6613-4269-a15f-971151225c22"
    client_secret = "aSPCLLzdCNHfG32ICGt1iCn2X6t1W-4_yz"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  tags = {
    environment = "shaapp-backend"
  }
}


resource "azurerm_virtual_network" "shaapp" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.shabackend.name
  location            = azurerm_resource_group.shabackend.location
  address_space       = ["10.0.0.0/16"]
}
output "client_certificate" {
  value = azurerm_kubernetes_cluster.shaapp.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.shaapp.kube_config_raw
}