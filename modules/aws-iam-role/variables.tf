
/* variable "aws_account_id" {
  type        = string
  description = "The AWS account ID."
  default     = ""
} */

variable "stage" {
  type        = string
  description = "The stage of the infrastructure."
  default     = "dev"
}

variable "project" {
  type        = string
  description = "The project name of the infrastructure."
  default     = "project"
}

variable "role_name" {
  type        = string
  description = "The name of the role."
  default     = "role"
}

variable "policies" {
  description = "A list of policy documents to attach to the role. Each document is a JSON string."
  type = list(object({
    sid        = string
    effect     = string
    actions    = list(string)
    resources  = list(string)
    principals = map(string)
    condition  = map(string)
  }))
  default = [
    {
      sid        = "AllowAll"
      effect     = "Allow"
      actions    = ["*"]
      resources  = ["*"]
      principals = {}
      condition  = {}
    },
  ]
}
