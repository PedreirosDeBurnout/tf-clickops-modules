terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.67.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.22.0"
    }
  }
}

# For authentication, the Helm provider can get its configuration by supplying a path to your kubeconfig file.
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Used to interact with the resources supported by Kubernetes.
# The provider needs to be configured with the proper credentials before it can be used.
provider "kubernetes" {
  config_path = "~/.kube/config"
}
