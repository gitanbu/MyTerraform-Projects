
/*resource "kubernetes_namespace" "shaapp" {
  metadata {
    annotations = {
      name = "shabackendapp"
    }

    labels = {
      mylabel = "sha-label"
    }

    name = "sha-backend-app"
  }
  
}


resource "kubernetes_namespace" "prometheus" {
  metadata {
    annotations = {
      name = "prometheus"
    }

    labels = {
      mylabel = "Prometheus-label"
    }

    name = "prometheus"
  }
  
}


resource "kubernetes_namespace" "grafana" {
  metadata {
    annotations = {
      name = "grafana"
    }

    labels = {
      mylabel = "grafana-label"
    }

    name = "grafana"
  }
  
}

resource "null_resource" "serviceaccount" {
  provisioner "local-exec" {
     command = "kubectl create serviceaccount cluster-admin-dashboard-sa"
  }
}


resource "null_resource" "clusterrolebinding" {
  provisioner "local-exec" {
     command = "kubectl create clusterrolebinding cluster-admin-dashboard-sa --clusterrole=cluster-admin --serviceaccount=default:cluster-admin-dashboard-sa"
  }
}


provider "kubernetes" {
  # your kubernetes provider config
}

/*module "kubernetes_dashboard" {
  source  = "cookielab/dashboard/kubernetes"
  version = "0.11.0"

  kubernetes_namespace_create = true
  kubernetes_dashboard_csrf   = "<your-csrf-random-string>"
}*/



/*resource "kubernetes_namespace" "integration-service" {
  metadata {
    annotations = {
      name = "integration-service"
    }

    labels = {
      mylabel = "integration-service-label"
    }

    name = "integration-service"
  }
  
}*/