# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

locals {
  addon_ebs_csi = "ebs_csi"
  aws_load_balancer_controller = "aws_load_balancer_controller"
}

module "irsa_ebs_csi" {
  count = contains(var.addons, local.addon_ebs_csi) ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${var.eks.cluster_name}"
  provider_url                  = var.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs_csi" {
  count = contains(var.addons, local.addon_ebs_csi) ? 1 : 0

  cluster_name             = var.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa_ebs_csi[0].iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
  }
}
