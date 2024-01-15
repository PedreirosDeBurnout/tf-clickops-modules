<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to evaluate if EBS optimized is an option | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_answer"></a> [answer](#output\_answer) | Returns 1 (true) or 0 (false) depending on if the instance type is able to be EBS optimized |
<!-- END_TF_DOCS -->
