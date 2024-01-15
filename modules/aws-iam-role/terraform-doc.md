<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policies"></a> [policies](#input\_policies) | A list of policy documents to attach to the role. Each document is a JSON string. | <pre>list(object({<br>    sid        = string<br>    effect     = string<br>    actions    = list(string)<br>    resources  = list(string)<br>    principals = map(string)<br>    condition  = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "actions": [<br>      "*"<br>    ],<br>    "condition": {},<br>    "effect": "Allow",<br>    "principals": {},<br>    "resources": [<br>      "*"<br>    ],<br>    "sid": "AllowAll"<br>  }<br>]</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | The project name of the infrastructure. | `string` | `"project"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the role. | `string` | `"role"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage of the infrastructure. | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The ARN of the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role |
<!-- END_TF_DOCS -->
