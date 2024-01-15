resource "helm_release" "argocd" {
  name             = var.argo_name
  repository       = var.argo_repository
  chart            = var.argo_chart
  namespace        = var.argo_namespace
  version          = var.argo_version
  create_namespace = var.argo_create_namespace
  wait             = false

  dynamic "set" {
    for_each = var.argocd_settings
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

}

resource "kubectl_manifest" "argo_app" {
  count     = 0
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apps-manager
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: apps-manager
    server: "https://kubernetes.default.svc"
  source:
    path: "terraform/dev/us-west-1/services/apps"
    repoURL: "git@github.com:Torch-Networks/Ecomm.git"
    targetRevision: "master"
    helm:
      valueFiles:
        - "values.yaml"
  project: "devops"
  syncPolicy:
    managedNamespaceMetadata:
      labels:
        managed: "argo-cd"
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PruneLast=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        maxDuration: 3m0s
        factor: 2
YAML

  depends_on = [helm_release.argocd]

}

resource "kubectl_manifest" "argo_project" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: devops
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: "kube services"
  sourceRepos:
    - '*'
  destinations:
    - namespace: "*"
      server: https://kubernetes.default.svc
      name: in-cluster
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  namespaceResourceBlacklist:
    - group: ''
      kind: ResourceQuota
    - group: ''
      kind: LimitRange
    - group: ''
      kind: NetworkPolicy
  namespaceResourceWhitelist:
    - group: '*'
      kind: '*'
  orphanedResources:
    warn: false
YAML

  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "argo_apps" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: app-of-apps
    server: "https://kubernetes.default.svc"
  source:
    path: "terraform/dev/us-west-1/services/system"
    repoURL: "git@github.com:Torch-Networks/Ecomm.git"
    targetRevision: "feature/rds"
    helm:
      valueFiles:
        - "values.yaml"
  project: "devops"
  syncPolicy:
    managedNamespaceMetadata:
      labels:
        managed: "argo-cd"
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PruneLast=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        maxDuration: 3m0s
        factor: 2
YAML

  depends_on = [helm_release.argocd]

}


resource "kubectl_manifest" "argo_secret" {
  for_each = { for s in var.secrets : s.secret_name => s }

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ${each.value.secret_name}
  namespace: ${var.argo_namespace}
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: ${each.value.type}
  url: ${each.value.url}
  sshPrivateKey: |
    ${each.value.secret}
  insecure: "true" # Ignore validity of server's TLS certificate. Defaults to "false"
  enableLfs: "true" # Enable git-lfs for this repository. Defaults to "false"
YAML

  depends_on = [helm_release.argocd]

}

resource "kubernetes_ingress_v1" "argo_cd_ingress" {
  depends_on = [helm_release.argocd]

  metadata {
    name      = "argocd"
    namespace = var.argo_namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/backend-protocol"      = "HTTPS"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "300"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "300"
      "nginx.ingress.kubernetes.io/proxy-send-timeout"    = "300"
      "ingress.kubernetes.io/force-ssl-redirect"          = "true"
      "external-dns.alpha.kubernetes.io/hostname"         = "argocd.sandbox.test.internal.reecedev.us"
      "nginx.ingress.kubernetes.io/ssl-passthrough"       = "true"
    }
  }

  spec {
    tls {
      hosts       = ["argocd.sandbox.test.internal.reecedev.us"]
      secret_name = "internal-reecedev"
    }
    ingress_class_name = "nginx"
    rule {
      host = "argocd.sandbox.test.internal.reecedev.us"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "argocd-server"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
}
