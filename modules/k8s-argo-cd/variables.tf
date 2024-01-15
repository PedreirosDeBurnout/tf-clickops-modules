## Argo Helm

variable "argo_name" {
  description = "Name of the application"
  type        = string
  default     = "argocd"
}

variable "argo_repository" {
  description = "Repository URL for the Helm chart"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argo_chart" {
  description = "Name of the Helm chart"
  type        = string
  default     = "argo-cd"
}

variable "argo_namespace" {
  description = "Namespace where the application will be deployed"
  type        = string
  default     = "argocd"
}

variable "argo_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "5.43.4"
}

variable "argo_create_namespace" {
  description = "Whether to create the namespace or not"
  type        = bool
  default     = true
}


variable "argocd_settings" {
  type = map(object({
    name  = string
    value = string
  }))
  default = {
    metris = { name = "server.metrics.enabled", value = "true" }
    "content" = {
      name  = "controller.metrics.enabled",
      value = "true"

    }

  }

  description = "a set of values to manually configure ArgoCD"
}

## secret

variable "secrets" {
  description = "List of secret configurations"
  type = list(object({
    secret_name = string
    type        = string
    url         = string
    secret      = string
  }))
}
