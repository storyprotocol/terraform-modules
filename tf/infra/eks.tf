module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = var.params.eks_managed_node_group_default_ami_type
  }

  eks_managed_node_groups = var.params.eks_managed_node_groups
}

module "eks_addons" {
  source = "./eks-addons"

  eks    = module.eks
  addons = var.params.eks_addons

}

resource "null_resource" "eks" {
  depends_on = [module.eks, module.eks_addons]

  triggers = {
    aws_account_id = data.aws_caller_identity.current.account_id
    cluster_name   = local.cluster_name
  }

  # provisioner "local-exec" {
  #   command = "${path.module}/../../bin/post-create ${self.triggers.aws_account_id} ${self.triggers.cluster_name}"
  # }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "${path.module}/../../bin/before-delete ${self.triggers.aws_account_id} ${self.triggers.cluster_name}"
  # }
}

