module "cluster_autoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = ["ecomm"]

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
      namespace_service_accounts = ["autoscaler:autoscaling-development-aws-cluster-autoscaler"]
    }
  }

}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
      namespace_service_accounts = ["ebs-csi-driver:ebs-csi-controller-sa"]
    }
  }


}

module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
      namespace_service_accounts = ["external-dns-system:external-dns-development"]
    }
  }

}


# module "external_secrets_irsa_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name                                          = "external-secrets"
#   attach_external_secrets_policy                     = true
#   external_secrets_ssm_parameter_arns                = ["arn:aws:ssm:*:*:parameter/*"]


# #   external_secrets_secrets_manager_arns              = ["arn:aws:secretsmanager:*:*:secret:bar"]
# #   external_secrets_kms_key_arns                      = ["arn:aws:kms:*:*:key/1234abcd-12ab-34cd-56ef-1234567890ab"]
#   external_secrets_secrets_manager_create_permission = false

#   oidc_providers = {
#     ex = {
#       provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
#       namespace_service_accounts = ["external-secrets:external-secrets-development"]
#     }

#   }

# }

module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "external-secrets-policy"

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : "ssm:DescribeParameters",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:ssm:*:*:parameter/*"
      },
      {
        "Action" : "secretsmanager:ListSecrets",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:GetSecretValue",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:DescribeSecret"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:secretsmanager:*:*:secret:*"
      },
      {
        "Action" : "kms:Decrypt",
        "Effect" : "Allow",
        "Resource" : "arn:aws:kms:*:*:key/*"
      },
      {
        "Action" : "tag:GetResources",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ],
    "Version" : "2012-10-17"
  })

}

module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "external-secret"

  role_policy_arns = {
    policy = module.iam_policy.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
      namespace_service_accounts = ["external-secrets:external-secrets-development"]
    }

  }
}


module "efs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.cluster_identity_oidc_issuer_url}"
      namespace_service_accounts = ["efs-csi-driver:efs-csi-controller-sa"]
    }
  }

}
