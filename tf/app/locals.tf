data "aws_caller_identity" "this" {}

# Use for rotating resource more easily
resource "random_string" "secret_suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  aws_account_id = data.aws_caller_identity.this.account_id

  name              = "${var.global.prefix}-${var.name}"
  oidc_provider_url = var.oidc_provider_url
  name_uniq         = "${local.name}-${random_string.secret_suffix.result}"

  k8s_namespace       = var.name
  k8s_sa_name         = "default"
  k8s_sa_policy_names = toset(var.params.sa_policies)

  s3 = var.params.s3
  db = var.params.db
}

