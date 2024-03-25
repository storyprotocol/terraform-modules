# Filter out local zones not currently supported
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "this" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "vpc-${var.cluster_name}"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# data "aws_security_groups" "vpc_sgs" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }
# }

resource "null_resource" "this" {
  depends_on = [module.this]

  triggers = {
    # vpc_sgs        = join(",", data.aws_security_groups.this.arns)
    # aws_account_id = local.aws_account_id
    # aws_region     = local.aws_region
    vpc_id         = module.this.vpc_id
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/../../../bin/delete-sgs ${self.triggers.vpc_id}"
  }
}

