output "helm_release_name" {
  description = "helm release name"
  value       = helm_release.argocd.name
}

output "helm_release_namespace" {
  description = "helm release namespace"
  value       = helm_release.argocd.namespace
}
