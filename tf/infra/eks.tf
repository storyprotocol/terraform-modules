# Filter out local zones not currently supported
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
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
    aws_account_id = local.aws_account_id
    aws_region     = local.aws_region
    cluster_name   = local.cluster_name
    vpc_id         = module.vpc.vpc_id
    vpc_sgs        = join(",", data.aws_security_groups.this.arns)
  }

  provisioner "local-exec" {
    command = "${path.module}/../../bin/post-create ${self.triggers.aws_account_id} ${self.triggers.aws_region} ${self.triggers.cluster_name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/../../bin/before-delete ${self.triggers.aws_account_id} ${self.triggers.aws_region} ${self.triggers.cluster_name}"
  }
}

