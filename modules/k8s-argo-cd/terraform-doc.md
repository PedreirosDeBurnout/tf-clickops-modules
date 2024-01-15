<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.67.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.10.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.10.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.10.1/docs/resources/release) | resource |
| [kubectl_manifest.argo_app](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argo_apps](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argo_project](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argo_secret](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_ingress_v1.argo_cd_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_destination"></a> [app\_destination](#input\_app\_destination) | the destination | `string` | `"https://kubernetes.default.svc"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | `""` | no |
| <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace) | the namespace | `string` | `"default"` | no |
| <a name="input_app_path"></a> [app\_path](#input\_app\_path) | path from where argo will monitoring | `string` | `""` | no |
| <a name="input_app_prune"></a> [app\_prune](#input\_app\_prune) | Flag to determine if pruning should be enabled | `bool` | `true` | no |
| <a name="input_argo_chart"></a> [argo\_chart](#input\_argo\_chart) | Name of the Helm chart | `string` | `"argo-cd"` | no |
| <a name="input_argo_create_namespace"></a> [argo\_create\_namespace](#input\_argo\_create\_namespace) | Whether to create the namespace or not | `bool` | `true` | no |
| <a name="input_argo_name"></a> [argo\_name](#input\_argo\_name) | Name of the application | `string` | `"argocd"` | no |
| <a name="input_argo_namespace"></a> [argo\_namespace](#input\_argo\_namespace) | Namespace where the application will be deployed | `string` | `"argocd"` | no |
| <a name="input_argo_repository"></a> [argo\_repository](#input\_argo\_repository) | Repository URL for the Helm chart | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_argo_version"></a> [argo\_version](#input\_argo\_version) | Version of the Helm chart | `string` | `"5.43.4"` | no |
| <a name="input_argocd_settings"></a> [argocd\_settings](#input\_argocd\_settings) | a set of values to manually configure ArgoCD | <pre>map(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>{<br>  "content": {<br>    "name": "controller.metrics.enabled",<br>    "value": "true"<br>  },<br>  "metris": {<br>    "name": "server.metrics.enabled",<br>    "value": "true"<br>  }<br>}</pre> | no |
| <a name="input_repo_url"></a> [repo\_url](#input\_repo\_url) | the repository that argoCd will monitoring | `string` | `""` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secret configurations | <pre>list(object({<br>    secret_name = string<br>    type        = string<br>    url         = string<br>    secret      = string<br>  }))</pre> | n/a | yes |
| <a name="input_self_heal"></a> [self\_heal](#input\_self\_heal) | Flag to determine if self-healing should be enabled | `bool` | `false` | no |
| <a name="input_target_revision"></a> [target\_revision](#input\_target\_revision) | Target revision of the application | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | helm release name |
| <a name="output_helm_release_namespace"></a> [helm\_release\_namespace](#output\_helm\_release\_namespace) | helm release namespace |
<!-- END_TF_DOCS -->
