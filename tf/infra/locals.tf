data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.name

  cluster_name               = "${var.global.prefix}-eks"
  cluster_alb_ctrl_namespace = "kube-system"
  cluster_alb_ctrl_saname    = "aws-load-balancer-controller"
}

