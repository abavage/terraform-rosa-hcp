provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}


resource "kubernetes_namespace" "one" {
  metadata {
    annotations = {
      name = "one"
    }

    labels = {
      myname = "one"
    }

    name = "one"
  }
}
