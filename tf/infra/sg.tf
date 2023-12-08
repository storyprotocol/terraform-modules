data "aws_security_groups" "this" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

